//
//  IB.m
//  Flatland
//
//  Created by Stefan Matthias Aust on 19.03.13.
//  Copyright (c) 2013 Proximity Technologies. All rights reserved.
//

#import "IB.h"

// #define USE_PLAIN_TEXT

@interface UIView (IB)

- (void)configureWithDefition:(NSDictionary *)definition;

@end

@interface IB ()

@property UIView *view;
@property NSMutableDictionary *definitions;
@property UIEdgeInsets padding;
@property CGFloat y;
@property CGFloat gap;
@property IBMode mode;

@end

@implementation IB

- (id)init {
    return [self initWithView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)]];
}

- (id)initWithView:(UIView *)view {
    self = [super init];
    self.view = view;
    self.definitions = [NSMutableDictionary dictionary];
    self.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    self.y = 0;
    self.gap = 10;
    self.mode = IBModeFill;
    return self;
}

- (void)define:(NSString *)name as:(NSDictionary *)definition {
    self.definitions[name] = definition;
}

- (void)defineKind:(NSString *)name as:(NSDictionary *)definition {
    self.definitions[[@"kind-" stringByAppendingString:name]] = definition;
}

- (void)gap:(CGFloat)gap {
    self.gap = gap;
}

- (void)padding:(NSString *)padding {
    NSArray *paddings = [padding componentsSeparatedByString:@" "];
    if ([paddings count] == 0) {
        self.padding = UIEdgeInsetsZero;
    } else if ([paddings count] == 1) {
        CGFloat p = [paddings[0] floatValue];
        self.padding = UIEdgeInsetsMake(p, p, p, p);
    } else if ([paddings count] == 2) {
        CGFloat p1 = [paddings[0] floatValue];
        CGFloat p2 = [paddings[1] floatValue];
        self.padding = UIEdgeInsetsMake(p1, p2, p1, p2);
    } else {
        self.padding = UIEdgeInsetsMake([paddings[0] floatValue],
                                        [paddings[3] floatValue],
                                        [paddings[2] floatValue],
                                        [paddings[1] floatValue]);
    }
}

- (void)sizeToFit {
    CGFloat dy = self.y + self.padding.bottom - self.view.frame.size.height;
    BOOL move = NO;
    for (UIView *view in self.view.superview.subviews) {
        if (move) {
            CGRect frame = view.frame;
            frame.origin.y += dy;
            view.frame = frame;
        } else {
            if (view == self.view) {
                CGRect frame = view.frame;
                frame.size.height += dy;
                view.frame = frame;
                move = YES;
            }
        }
    }
    CGRect frame = self.view.superview.frame;
    frame.size.height += dy;
    self.view.superview.frame = frame;
}

- (void)pack {
    CGRect frame = self.view.frame;
    frame.size.height = self.y + self.padding.bottom;
    self.view.frame = frame;
}

- (void)mode:(IBMode)mode {
    self.mode = mode;
}

- (void)add:(UIView *)view {
    UIEdgeInsets padding = self.padding;
    CGFloat width = self.view.bounds.size.width - padding.left - padding.right;
    CGRect frame = view.frame;
    switch (self.mode) {
        case IBModeManual:
            break;
        case IBModeLeft:
            frame.origin.x = padding.left;
            view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            break;
        case IBModeRight:
            frame.origin.x = width - frame.size.width - padding.right;
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            break;
        case IBModeCenter:
            frame.origin.x = (width - frame.size.width) / 2 + padding.left;
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
            break;
        case IBModeFill:
            frame.origin.x = padding.left;
            frame.size.width = width;
            view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            break;
    }
    if (self.mode != IBModeManual) {
        frame.origin.y = padding.top + self.y;
        self.y += frame.size.height;
        self.y += self.gap;
        view.frame = frame;
        view.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    }
    [self.view addSubview:view];
}

- (void)add:(UIView *)view at:(NSString *)position {
    [self setFrameOfView:view fromPosition:position];
    [self.view addSubview:view];
}

- (void)addGap:(CGFloat)gap {
    self.y += gap;
}

#pragma mark - factory methods

- (UIView *)heading:(NSString *)text {
    return [self label:text with:@{@"font": [UIFont regularFontOfSize:18]}];
}

- (UIView *)paragraph:(NSString *)text {
    NSDictionary *definition = @{@"font": [UIFont lightFontOfSize:13]};
    
    // check whether this is a bullet list item or a simple paragraph of text
    NSRange range = [text rangeOfString:@"\t"];
    if (range.location != NSNotFound) {
        // create a label with everything before the TAB, that is the bullet point character
        UILabel *bulletLabel = [self label:[text substringToIndex:range.location] with:definition];
        
        const CGFloat indent = 40;
        
        UIEdgeInsets padding = self.padding;
        padding.left += indent;
        self.padding = padding;
        UILabel *textLabel = [self label:[text substringFromIndex:range.location + range.length] with:definition];
        padding.left -= indent;
        self.padding = padding;
        
        CGRect frame = CGRectMake(bulletLabel.frame.origin.x,
                                  bulletLabel.frame.origin.y,
                                  textLabel.frame.size.width + indent,
                                  textLabel.frame.size.height);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        
        frame = bulletLabel.frame;
        frame.origin.x = 10;
        frame.origin.y = 0;
        frame.size.width = indent - 10;
        bulletLabel.frame = frame;
        
        frame = textLabel.frame;
        frame.origin.x = indent;
        frame.origin.y = 0;
        textLabel.frame = frame;
        
        [view addSubview:bulletLabel];
        [view addSubview:textLabel];
        return view;
    } else {
        return [self label:text with:definition];
    }
}

- (UILabel *)label:(NSString *)text with:(NSDictionary *)definition {
    definition = [self merge:definition with:@{@"text": text, @"kind": @"label", @"background": [UIColor clearColor]}];
    UILabel *label = [self make:@"label" class:[UILabel class] withDefinition:definition];
    
    CGFloat width = self.view.bounds.size.width - self.padding.left - self.padding.right;
#ifdef USE_PLAIN_TEXT
    CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(width, 1e6)];
#else
    CGSize size = [label.attributedText boundingRectWithSize:CGSizeMake(width, 1e6)
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     context:NULL].size;
#endif
    
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByClipping;
    label.frame = CGRectMake(0, 0, width, size.height);
    return label;
}

- (UIImageView *)image:(NSString *)name {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
}

- (UIButton *)button:(NSString *)name {
    return [self button:name with:@{}];
}

- (UIButton *)button:(NSString *)name with:(NSDictionary *)definition {
    return (UIButton *) [self make:name class:[UIButton class] withDefinition:definition];
}

#pragma mark - private methods

- (void)setFrameOfView:(UIView *)view fromPosition:(NSString *)position {
    NSArray *parts = [position componentsSeparatedByString:@","];
    if ([parts count] < 2 || [parts count] > 4) {
        [NSException raise:NSInvalidArgumentException format:@"%@", position];
    }

    CGFloat width = self.view.bounds.size.width - self.padding.left - self.padding.right;
    CGFloat height = self.view.bounds.size.height - self.padding.top - self.padding.bottom;
    unichar ch;
    
    CGFloat x = [parts[0] floatValue];
    if (x < 0) {
        x += width;
    }
    
    ch = [parts[0] characterAtIndex:[parts[0] length] - 1];
    if (ch == 'L' || ch == 'C') {
        view.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin;
    }
    if (ch == 'R' || ch == 'C') {
        view.autoresizingMask |= UIViewAutoresizingFlexibleRightMargin;
    }
    
    CGFloat y = [parts[1] floatValue];
    if (x < y) {
        x += height;
    }

    ch = [parts[1] characterAtIndex:[parts[1] length] - 1];
    if (ch == 'T' || ch == 'C') {
        view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin;
    }
    if (ch == 'B' || ch == 'C') {
        view.autoresizingMask |= UIViewAutoresizingFlexibleBottomMargin;
    }

    CGFloat w, h;
    
    if ([parts count] > 2) {
        w = [parts[2] floatValue];
        if (w < 0) {
            w += width;
        }
        ch = [parts[2] characterAtIndex:[parts[2] length] - 1];
        if (ch == 'W') {
            view.autoresizingMask |= UIViewAutoresizingFlexibleWidth;
        }
        if (ch == 'C') {
            view.autoresizingMask |= UIViewAutoresizingFlexibleLeftMargin + UIViewAutoresizingFlexibleRightMargin;
        }
    } else {
        w = view.bounds.size.width;
    }
    
    if ([parts count] > 3) {
        h = [parts[3] floatValue];
        if (h < 0) {
            h += height;
        }
        ch = [parts[3] characterAtIndex:[parts[3] length] - 1];
        if (ch == 'H') {
            view.autoresizingMask |= UIViewAutoresizingFlexibleHeight;
        }
        if (ch == 'C') {
            view.autoresizingMask |= UIViewAutoresizingFlexibleTopMargin + UIViewAutoresizingFlexibleBottomMargin;
        }
    } else {
        h = view.bounds.size.height;
    }
    
    view.frame = CGRectMake(x, y, w, h);
}

- (id)make:(NSString *)name class:(Class)class withDefinition:(NSDictionary *)definition {
    definition = [self merge:@{@"class": class} with:definition];
    definition = [self merge:definition with:self.definitions[name]];
    definition = [self merge:definition with:self.definitions[definition[@"kind"]]];
    
    UIView *view = [[definition[@"class"] alloc] initWithFrame:CGRectZero];
    if (!view) {
        [NSException raise:NSInvalidArgumentException format:@"cannot make %@", name];
    }
    
    [view configureWithDefition:definition];
    
    return view;
}

- (NSDictionary *)merge:(NSDictionary *)dictionary with:(NSDictionary *)defaults {
    if (!defaults) {
        return dictionary;
    }
    NSMutableDictionary *merged = [defaults mutableCopy];
    [merged addEntriesFromDictionary:dictionary];
    return merged;
}

@end

static UIFont *GetFont(NSDictionary *definition, NSString *name) {
    id value = definition[name];
    if (!value) {
        return value;
    }
    if ([value isKindOfClass:[UIFont class]]) {
        return value;
    }
    [NSException raise:NSInvalidArgumentException format:@"not a font %@", value];
    return nil;
}


static NSString *GetText(NSDictionary *definition, NSString *name) {
    id value = definition[name];
    if (!value) {
        return value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    [NSException raise:NSInvalidArgumentException format:@"not a text %@", value];
    return nil;
}

static UIColor *GetColor(NSDictionary *definition, NSString *name) {
    id value = definition[name];
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        if (![value hasPrefix:@"#"]) {
            value = definition[[@"color-" stringByAppendingString:value]];
        }
        if ([value isKindOfClass:[NSString class]]) {
            if ([value hasPrefix:@"#"]) {
                return [UIColor colorWithRGBString:value];
            }
            [NSException raise:NSInvalidArgumentException format:@"invalid color name %@", definition[name]];
        }
    }
    if ([value isKindOfClass:[UIColor class]]) {
        return value;
    }
    [NSException raise:NSInvalidArgumentException format:@"not a color %@", value];
    return nil;
}

static UIImage *GetImage(NSDictionary *definition, NSString *name) {
    id value = definition[name];
    if (!value) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        UIImage *image = [UIImage imageNamed:value];
        if (image) {
            return image;
        }
        value = definition[[@"image-" stringByAppendingString:value]];
        if ([value isKindOfClass:[NSString class]]) {
            UIImage *image = [UIImage imageNamed:value];
            if (image) {
                return image;
            }
        }
    }
    if ([value isKindOfClass:[UIImage class]]) {
        return value;
    }
    [NSException raise:NSInvalidArgumentException format:@"not an image %@", value];
    return nil;
}


@implementation UIView (IB)

- (void)configureWithDefition:(NSDictionary *)definition {
    UIColor *backgroundColor = GetColor(definition, @"background");
    if (backgroundColor) {
        self.backgroundColor = backgroundColor;
    }
}

@end

@implementation UILabel (IB)

- (void)configureWithDefition:(NSDictionary *)definition {
    [super configureWithDefition:definition];
    UIFont *font = GetFont(definition, @"font");
    if (font) {
        self.font = font;
    }
    NSString *text = GetText(definition, @"text");
    if (text) {
#ifdef USE_PLAIN_TEXT
        self.text = text;
#else
        self.attributedText = [text attributedTextFromHTMLStringWithFont:self.font];
#endif
    }
    UIColor *textColor = GetColor(definition, @"textColor");
    if (textColor) {
        self.textColor = textColor;
    }
}

@end

@implementation UIButton (IB)

- (void)configureWithDefition:(NSDictionary *)definition {
    [super configureWithDefition:definition];
    NSString *title = GetText(definition, @"title");
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    UIColor *titleColor = GetColor(definition, @"titleColor");
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    UIImage *image = GetImage(definition, @"image");
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
    }
    UIImage *backgroundImage = GetImage(definition, @"backgroundImage");
    if (backgroundImage) {
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
}

@end
