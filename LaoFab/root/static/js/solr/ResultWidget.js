(function ($) {

AjaxSolr.ResultWidget = AjaxSolr.AbstractWidget.extend({
  start: 0,

  beforeRequest: function () {
    $(this.target).html($('<img>').attr('src', 'images/ajax-loader.gif'));
  },

  facetLinks: function (facet_field, facet_values) {
    var links = [];
    if (facet_values) {
      for (var i = 0, l = facet_values.length; i < l; i++) {
        if (facet_values[i] !== undefined) {
          links.push(
            $('<a href="#"></a>')
            .text(facet_values[i])
            .click(this.facetHandler(facet_field, facet_values[i]))
          );
        }
        else {
          links.push('no items found in current selection');
        }
      }
    }
    return links;
  },

  facetHandler: function (facet_field, facet_value) {
    var self = this;
    return function () {
      self.manager.store.remove('fq');
      self.manager.store.addByValue('fq', facet_field + ':' + AjaxSolr.Parameter.escapeValue(facet_value));
      self.doRequest();
      return false;
    };
  },

  afterRequest: function () {
    $(this.target).empty();
    for (var i = 0, l = this.manager.response.response.docs.length; i < l; i++) {
      var doc = this.manager.response.response.docs[i];
      var hl = this.manager.response.highlighting[doc.id];
      $(this.target).append(this.template(doc, hl));

      var items = [];
      items = items.concat(this.facetLinks('author', doc.author_name));
      items = items.concat(this.facetLinks('organisation', doc.author_organisation));
      items = items.concat(this.facetLinks('subcat', doc.subcat));
      items = items.concat(this.facetLinks('pubyear', [doc.pubyear]));

      var $links = $('#links_' + doc.id);
      $links.empty();
      for (var j = 0, m = items.length; j < m; j++) {
        $links.append($('<li></li>').append(items[j]));
      }
    }
  },

  template: function (doc, hl) {
    var snippet = '';
    if (hl.text) {
      snippet = hl.text;
    }

    var output = '<div class="docres"><h2><a href="/document/view/'+ doc.id +'">' + doc.title;
    if (doc.sub_title)
        output += ' - ' + doc.sub_title;
    output += '</a></h2>';
    if (doc.preview) {
        output += '<a href="#" onClick="Messi.img(' + "'/static/images/doc/prev/" + doc.id + ".jpg', {title: '" + doc.title + "', modal: true});" + '"  class="docthumb">';
        output += '<img src="/static/images/doc/thumb/' + doc.id + '.jpg" alt="thumbnail for ' + doc.title + '" border="0"/></a>';
    }
    output += '<p id="links_' + doc.id + '" class="links"></p>';
    output += '<p>' + snippet + '</p></div>';
    return output;
  },

  init: function () {
    $(document).on('click', 'a.more', function () {
      var $this = $(this),
          span = $this.parent().find('span');

      if (span.is(':visible')) {
        span.hide();
        $this.text('more');
      }
      else {
        span.show();
        $this.text('less');
      }

      return false;
    });
  }
});

})(jQuery);
