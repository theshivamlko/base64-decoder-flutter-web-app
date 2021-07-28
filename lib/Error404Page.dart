import 'dart:html' as html;
import 'dart:ui' as ui;

class ErrorPage {
  String tagName = 'error-404';
  ErrorPage.create() {
    html.IFrameElement iFrameElement = html.IFrameElement();
    iFrameElement.src="https://navoki.com";
    ui.platformViewRegistry.registerViewFactory(tagName, (int id) => iFrameElement);
  }
}
