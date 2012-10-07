(function ($) {
	AjaxSolr.ResultWidget = AjaxSolr.AbstractWidget.extend({
      start: 0,

      beforeRequest: function () {
        $(this.target).html($('<img/>').attr('src', "/images/ajax-loader.gif"));
      },

      facetLinks: function (facet_field, facet_values) {
        var links = [];
        if (facet_values) {
          for (var i = 0, l = facet_values.length; i < l; i++) {
            if (facet_values[i] !== undefined) {
              links.push(AjaxSolr.theme('facet_link', facet_values[i], this.facetHandler(facet_field, facet_values[i])));
            }
            else {
              links.push(AjaxSolr.theme('no_items_found'));
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
          var res ={};
          res['doc'] = this.manager.response.response.docs[i];
          res['hl'] = this.manager.response.highlighting[res['doc'].id];
          $(this.target).append(AjaxSolr.theme('result', res, AjaxSolr.theme('snippet', res)));

          var items = [];
 //         items = items.concat(this.facetLinks('doc_folder', res.doc.doc_folder));
          items = items.concat(this.facetLinks('doc_keyword', res.doc.doc_keyword));
          AjaxSolr.theme('list_items', '#links_' + res.doc.id, items);
        }
      }
	});
})(jQuery);
