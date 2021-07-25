import 'dart:html' as html;
import 'dart:ui' as ui;

class Error404Page {
  String tagName = 'error-404';
  Error404Page.create() {
    html.IFrameElement iFrameElement = html.IFrameElement();
    iFrameElement.src="https://navoki.com/error-404";
    ui.platformViewRegistry.registerViewFactory(tagName, (int id) => iFrameElement);
  }
}
