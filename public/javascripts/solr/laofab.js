var Manager;

(function ($) {

  $(function () {
    Manager = new AjaxSolr.Manager({
      solrUrl: 'http://solr:8080/solr/'
      //solrUrl: 'http://evolvingweb.ca/solr/reuters/'
    });
    Manager.addWidget(new AjaxSolr.ResultWidget({
      id: 'result',
      target: '#docs'
    }));
    Manager.addWidget(new AjaxSolr.PagerWidget({
      id: 'pager',
      target: '#pager',
      prevLabel: '&lt;',
      nextLabel: '&gt;',
      innerWindow: 1,
      renderHeader: function (perPage, offset, total) {
        $('#pager-header').html($('<span/>').text('displaying ' + Math.min(total, offset + 1) + ' to ' + Math.min(total, offset + perPage) + ' of ' + total));
      }
    }));
    var fields = [ 'doc_keyword', 'doc_folder' ];
    for (var i = 0, l = fields.length; i < l; i++) {
      Manager.addWidget(new AjaxSolr.TagcloudWidget({
        id: fields[i],
        target: '#' + fields[i],
        field: fields[i]
      }));
    }
    Manager.addWidget(new AjaxSolr.CurrentSearchWidget({
      id: 'currentsearch',
      target: '#selection',
    }));
    Manager.addWidget(new AjaxSolr.TextWidget({
      id: 'text',
      target: '#search'
    }));
    Manager.init();
    Manager.store.addByValue('q', '*:*');
    Manager.store.addByValue('fl', 'id,score,doc_title,doc_sub_title,doc_author_name,doc_pubyear,doc_keyword,doc_folder');
    //Manager.store.addByValue('fl', 'doc_title,doc_sub_title,doc_author_name,doc_author_organisation,doc_pubyear,doc_subcat,doc_doctype,doc_folder,attr_content');
    Manager.store.addByValue('hl', 'true');
    Manager.store.addByValue('hl.fl', 'text');
    var params = {
      facet: true,
     'facet.field': [ 'doc_keyword', 'doc_folder' ],
     'facet.limit': 20,
     'facet.mincount': 1,
     'f.topics.facet.limit': 50,
     'json.nl': 'map'
    };
    for (var name in params) {
      Manager.store.addByValue(name, params[name]);
    }

    Manager.doRequest();
  });

})(jQuery);
