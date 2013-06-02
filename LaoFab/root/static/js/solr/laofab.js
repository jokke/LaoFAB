var Manager;
(function ($) {
  $(function () {
    Manager = new AjaxSolr.Manager({
      //proxyUrl: 'search/proxy' //'http://127.0.0.1:8983/solr/repo/'
      //solrUrl: 'http://127.0.0.1:8983/solr/repo/'
      //solrUrl: 'http://127.0.0.1:8983/solr/repo/'
      proxyUrl: '/rest/solr/'
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
        $('#pager-header').html($('<span></span>').text('displaying ' + Math.min(total, offset + 1) + ' to ' + Math.min(total, offset + perPage) + ' of ' + total));
      }
    }));
    var fields = [ 'pubyear', 'keyword', 'folder', 'doctype', 'organisation', 'author'];
    for (var i = 0, l = fields.length; i < l; i++) {
      Manager.addWidget(new AjaxSolr.TagcloudWidget({
        id: fields[i],
        target: '#' + fields[i],
        field: fields[i]
      }));
    }
    
    Manager.addWidget(new AjaxSolr.CurrentSearchWidget({
      id: 'currentsearch',
      target: '#selection'
    }));
    Manager.addWidget(new AjaxSolr.TextWidget({
      id: 'text',
      target: '#search'
    }));
/*    Manager.addWidget(new AjaxSolr.AutocompleteWidget({
        id: 'text',
        target: '#search',
        fields: fields
    }));*/
    Manager.init();
    Manager.store.addByValue('q', '*:*');
    var params = {
      facet: true,
      'facet.field': fields,
      'facet.limit': 20,
      'facet.mincount': 1,
      'f.topics.facet.limit': 50,
      'json.nl': 'map',
      'df': 'text'
    };
    for (var name in params) {
      Manager.store.addByValue(name, params[name]);
    }
    Manager.doRequest();
  });
})(jQuery);


