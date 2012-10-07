(function ($) {

AjaxSolr.theme.prototype.result = function (res, snippet) {
  var output = '<div><h2 class="result">' + res['doc'].doc_title + '</h2>';
  output += '<p id="links_' + res['doc'].id + '" class="links"></p>';
  output += '<p>' + snippet + '</p></div>';
  return output;
};

AjaxSolr.theme.prototype.snippet = function (res) {
  var output = 'Publication year: [' + res.doc.doc_pubyear + ']';
  output += '<br/><code style="background-color: pink">Id: ' + res.doc.id;
  output += '<br/>Score: ' + res.doc.score + '</code>';
  if (res.hl.text) 
    output += '<br />...' + res.hl.text.join('...<br/>...') + '...';
/*  var content = res.hl.text.join('...<br/>...');
  var output = '';
  if (content.length > 300) {
    output += res['doc'].doc_pubyear + ' ' + content.substring(0, 300);
    output += '<span style="display:none;">' + res['doc'].doc_title.substring(300);
    output += '</span> <a href="#" class="more">more</a>';
  }
  else {
    output += typeof (content);
  }*/
  return output;
};

AjaxSolr.theme.prototype.tag = function (value, weight, handler) {
  return $('<a href="#" class="tagcloud_item"/>').text(value).addClass('tagcloud_size_' + weight).click(handler);
};

AjaxSolr.theme.prototype.facet_link = function (value, handler) {
  return $('<a href="#"/>').text(value).click(handler);
};

AjaxSolr.theme.prototype.no_items_found = function () {
  return 'no items found in current selection';
};

})(jQuery);
