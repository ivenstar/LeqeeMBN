// Copyright 2013 I.C.N.H GmbH. All rights reserved.
import 'dart:async';
import 'dart:io';
import 'dart:json' as JSON;
import 'dart:uri' as uri;

// --------------------------------------------------------------------------------------------------------------------

/**
 * Reads a JSON object from a file at [path] and returns a [Future] with that object.
 */
Future<Object> readJson(String path) {
  Completer<Object> c = new Completer();
  new File(path).readAsString(encoding: Encoding.UTF_8)
    .then((content) => c.complete(JSON.parse(content)), onError: c.completeError);
  return c.future;
}

/**
 * Write a JSON object into a file at [path] and returns a [Future] on the file written.
 */
Future<File> writeJson(String path, Object object) {
  return new File(path).writeAsString(JSON.stringify(object), encoding: Encoding.UTF_8);
}

// --------------------------------------------------------------------------------------------------------------------

/**
 * Returns a [Handler] to serve static files from [directory] which defaults to `public`.
 * Sets a content type based on the file's extension.
 */
Handler staticFile([directory="public"]) {
  return (Request req, Response res) {
    String path = req.params['path'];
    if (path.contains("..")) return;
    print("${req._request.method} $path");
    if (path.endsWith(".html")) res.contentType("text/html");
    else if (path.endsWith(".css")) res.contentType("text/css");
    else if (path.endsWith(".js")) res.contentType("text/javascript");
    else if (path.endsWith(".png")) res.contentType("image/png");
    else if (path.endsWith(".gif")) res.contentType("image/gif");
    else res.contentType("application/octet-stream");
    new File("$directory/$path").readAsBytes().then(res.sendData, onError: res.notFound);
  };
}

// --------------------------------------------------------------------------------------------------------------------

/**
 * Wrapper for a dart [HttpRequest].
 * Has [params] to access URI parameters.
 * Has [body] to access data passed with a POST request.
 */
class Request {
  final HttpRequest _request;
  final Map<String, String> params;
  Map<String, String> body = {};

  Request(this._request, this.params);

  /**
   * Returns the request's content type.
   */
  String get contentType => _request.headers.contentType.value;

  /**
   * Parses the request's body, either a JSON object or encoded form data.
   */
  void parse(String body) {
    if (contentType.toLowerCase() == "application/json") {
      this.body = JSON.parse(body);
    } else {
      this.body = {};
      for (String part in body.split("&")) {
        List<String> parts = part.split("=");
        this.body[uri.decodeUriComponent(parts[0])] = uri.decodeUriComponent(parts[1]);
      }
    }
  }
}

/**
 * Wrapper for a dart [HttpResponse].
 * Has [contentType] method to set the content type.
 * Has [json], [html] and [text] methods to return a JSON object, HTML page or plain text.
 */
class Response {
  final HttpResponse _response;

  Response(this._response);

  /**
   * Sets the response's content type.
   */
  void contentType(String contentType) {
    _response.headers.contentType = ContentType.parse(contentType);
  }

  /**
   * Adds the [object]'s print string to the response.
   */
  void Xwrite(Object object) {
    _response.write(object);
  }

  /**
   * Returns a JSON object.
   */
  void json(Object object, {status:200}) {
    contentType("application/json;charset=utf-8");
    send(JSON.stringify(object), status:status);
  }

  /**
   * Returns a HTML string.
   */
  void html(String html, {status:200}) {
    contentType("text/html;charset=utf-8");
    send(html, status:status);
  }
  
  /**
   * Returns a text string.
   */
  void text(String text, {status:200}) {
    contentType("text/plain;charset=utf-8");
    send(text, status:status);
  }

  /**
   * Returns a byte array, uninterpreted.
   * You should set the [contentType].
   */
  void sendData(List<int> data) {
    _response.add(data);
    _response.statusCode = HttpStatus.OK;
    _response.close();
  }

  /**
   * Sets the [statusCode], adds the optional [message] to the response and closes it.
   */
  void send(String message, {status:200}) {
    _response.statusCode = status;
    _response.write(message);
    _response.close().catchError((o) => print("Error while sending response: $o"));
  }
  
  void notFound(_) => text("Not found", status:HttpStatus.NOT_FOUND);
}

// --------------------------------------------------------------------------------------------------------------------

/**
 * A handler for the [Matcher].
 */
typedef void Handler(Request req, Response res);

/**
 * Handler for a specific HTTP method and URI.
 * The URI pattern may contain a `*` and `:name` segments.
 */
class Matcher {
  String method;
  List<String> names;
  RegExp pattern;
  Handler handler;

  /**
   * Constructs a new matcher instance.
   * Detects `*` and `:name` in [pattern] which are then extracted as request params. 
   */
  Matcher(String method, String pattern, Handler handler) {
    this.method = method.toUpperCase();
    this.names = new List();
    this.pattern = new RegExp("^" + pattern.replaceAllMapped(new RegExp("\\*"), (Match match) {
      names.add('path');
      return "(.*)";
    }).replaceAllMapped(new RegExp(":(\\w+)"), (Match match) {
      names.add(match[1]);
      return "([^/]*)";
    }) + "\$");
    this.handler = handler;
  }

  /**
   * Handles the [request] by calling this object's handler.
   */
  bool handle(HttpRequest request) {
    // does the request match?
    if (request.method != method) {
      return false;
    }

    Match match = pattern.firstMatch(request.uri.path);

    if (match == null) {
      return false;
    }

    // yes, it does match
    print("${request.method} ${request.uri.path}");

    // map URI parameters
    Map<String, String> params = {};
    names.asMap().forEach((i, name) { params[name] = match[i + 1]; });

    // wrap Dart HTTP request and Dart HTTP response
    Request req = new Request(request, params);
    Response res = new Response(request.response);

    // parse the request's body, then call the handler
    if (request.method == "POST" || request.method == "PUT") {
      request
        .transform(new StringDecoder())
        .fold("", (String body, String chunk) => body + chunk)
        .then((String body) {
          req.parse(body);
          handler(req, res);
        });
    } else {
      handler(req, res);
    }
    return true;
  }
}

/**
 * A server.
 * Use [get], [put], [post] and [delete] to add [Handler] functions for URI patterns.
 */
class Server {

  /**
   * Creates a new server listing on [port].
   * The [setup] function is called to setup the server's handlers.
   */
  static void bind(int port, void setup(Server server)) {
    HttpServer.bind('0.0.0.0', port).then((HttpServer server) => setup(new Server(server)));
  }

  final HttpServer _server;
  final List<Matcher> _matchers = [];

  Server(this._server) {
    _server.listen((HttpRequest request) {
      for (Matcher matcher in _matchers) {
        if (matcher.handle(request)) {
          return;
        }
      }
      new Response(request.response).send("Cannot ${request.method} ${request.uri.path}", status:HttpStatus.NOT_FOUND);
    });
  }

  void get(String pattern, Handler handler) => _match("GET", pattern, handler);

  void put(String pattern, Handler handler) => _match("PUT", pattern, handler);

  void post(String pattern, Handler handler) => _match("POST", pattern, handler);

  void delete(String pattern, Handler handler) => _match("DELETE", pattern, handler);

  void _match(String method, String pattern, Handler handler) { _matchers.add(new Matcher(method, pattern, handler)); }

  /**
   * Defines 5 paths for the usual operations.
   */
  void resource(String name, ResourceHandler handler) {
    get(name, handler.list);
    post(name, handler.create);
    get(name + "/:id", handler.read);
    put(name + "/:id", handler.update);
    delete(name + "/:id", handler.delete);
  }
}

// --------------------------------------------------------------------------------------------------------------------

abstract class ResourceHandler {
  void list(Request req, Response res);
  void create(Request req, Response res);
  void read(Request req, Response res);
  void update(Request req, Response res);
  void delete(Request req, Response res);
}

class FileResourceHandler extends ResourceHandler {
  final String path;

  FileResourceHandler(this.path) {
    if (!new Directory(path).existsSync()) {
      new Directory(path).createSync(recursive:true);
    }
  }

  String resourcePath(String id) {
    return "$path/$id";
  }

  void list(Request req, Response res) {
    new Directory(path).list().toList()
      .then((List<FileSystemEntity> list) => Future.wait(list.map((File f) => readJson(resourcePath(namePart(f))))))
      .then((List resource) => res.json(resource), onError: res.notFound);
  }

  void create(Request req, Response res) {
    nextId().then((String id) { // TODO racing condition
      req.body['id'] = id;
      req.body['success'] = true;
      writeJson(resourcePath(id), req.body)
        .then((_) => res.json(req.body, status:HttpStatus.CREATED), onError: res.notFound);
    });
  }

  void read(Request req, Response res) {
    readJson(resourcePath(req.params['id'])).then(res.json, onError: res.notFound);
  }

  void update(Request req, Response res) {
    String id = req.params['id'];
    req.body['id'] = id;
    req.body['success'] = true;
    writeJson(resourcePath(id), req.body)
      .then((_) => res.json(req.body, status:HttpStatus.OK), onError: res.notFound);
  }

  void delete(Request req, Response res) {
    new File(resourcePath(req.params['id'])).delete()
      .then((_) => res.send("", status:HttpStatus.NO_CONTENT), onError: res.notFound);
  }

  Future<String> nextId() {
    Completer c = new Completer();
    Set<String> ids = new Set();
    new Directory(path).list().toList()
      .then((List<FileSystemEntity> list) => new Set.from(list.map((FileSystemEntity f) => namePart(f))))
      .then((Set<String> ids) {
        for (int i = 1; i <= ids.length + 1; i++) {
          String id = i.toString();
          if (!ids.contains(id)) {
            c.complete(id);
            break;
          }
        }
      }).catchError(c.completeError);
    return c.future;
  }

  static String namePart(FileSystemEntity e) => e.path.split('/').last;
}