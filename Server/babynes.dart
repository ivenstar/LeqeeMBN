// Copyright 2013 I.C.N.H GmbH. All rights reserved.
import 'dart:async';
import 'dart:io';

import './server.dart';

const PORT = 4000;
const BASE = "/babynes";

void main() {
  Server.bind(PORT, (Server server) =>
    server
      ..get("$BASE/babies", (req, res) { // fake requesting the list of babies
        readJson("data/babies.json").then(res.json);
      })
      ..post("$BASE/login", (req, res) { // fake a login
        print("login: ${req.body}");
        res.json({"success": true, "token": "token"}); 
      })
      ..post("$BASE/orders", (req, res) { // fake posting orders
        print("post order: ${req.body}");
        res.json({
          "success": true, 
          "id": "4711-0815", 
          "paymentURL": "http://localhost:$PORT/babynes/payment"});
      })
      ..get("$BASE/payment", (req, res) { // this is the URL returned after creating an order
        res.html(
          "<h1>Payment</h1>"
          "<form action='ConfirmationDeCommande.aspx'><button>success</button></form>"
          "<form action='OrderError.aspx'><button>failure</button></form>");
      })
      ..post("$BASE/subscribe-for-balance", (req, res) { // fake subscribing
        print("balance subscription: ${req.body['email']}");
        res.json({"success": true});
      })
      ..get("$BASE/capsule-recommendation", (req, res) {
        readJson("data/recommendation.json").then(res.json);
      })
      ..get("$BASE/capsule-stock", (req, res) {
        readJson("data/stock.json").then(res.json);
      })
      ..put("$BASE/capsule-stock", (req, res) {
        req.body["success"] = true;
        writeJson("data/stock.json", req.body).then((_) => res.json(req.body));
      })
      ..get("$BASE/personalInformation", (req, res) {
        readJson("data/personalInformation.json").then(res.json);
      })
      ..put("$BASE/personalInformation", (req, res) {
        req.body["success"] = true;
        writeJson("data/personalInformation.json", req.body).then((_) => res.json(req.body));
      })
      ..resource("$BASE/deliveryAddresses", new FileResourceHandler("data/deliveryAddresses"))
      ..resource("$BASE/billingAddresses", new FileResourceHandler("data/billingAddresses"))
      ..resource("$BASE/paymentCards", new FileResourceHandler("data/paymentCards"))
      ..get("/*", staticFile()));
}
