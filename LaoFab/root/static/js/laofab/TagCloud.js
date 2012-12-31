if(!dojo._hasResource["laofab.TagCloud"]){dojo._hasResource["laofab.TagCloud"]=true;dojo.provide("laofab.TagCloud");dojo.require("dijit._Templated");dojo.require("dijit.layout.ContentPane");dojo.declare("laofab.TagCloud",[dijit.layout.ContentPane,dijit._Templated],{pageSize:Infinity,store:null,query:{},nameAttr:"name",slugAttr:"slug",countAttr:"count",sizeDifference:true,fontMaxSize:300,fontMinSize:100,weightDifference:false,showTitle:true,showCount:false,clickFunction:"tagItemClicked",baseClass:"TagCloud",_tagMin:null,_tagMax:null,templateString:"<div style=\"width:250px;\" class=\"${baseClass}\">\n</div>\n",postCreate:function(){var _1=dojo.clone(this.query);var _2=this.store.fetch({queryOptions:{ignoreCase:true,deep:true},query:_1,onComplete:dojo.hitch(this,"_displayTags"),onError:function(_3){console.error("laofab.TagCloud: "+_3);},start:0,count:this.pageSize});},_displayTags:function(_4,_5){if(!this._tagMin){this._getMaxMin(_4);}var _6=dojo.doc.createElement("ul");dojo.place(_6,this.domNode,"last");dojo.forEach(_4,function(_7){var _8=parseInt(this.store.getValue(_7,this.countAttr));var _9=this.store.getValue(_7,this.nameAttr);var _a=this.store.getValue(_7,this.slugAttr);if(!_a){_a=_9;}var _b=dojo.doc.createElement("li");dojo.place(_b,_6,"last");var _c=dojo.doc.createElement("a");if(this.sizeDifference){_c.style.fontSize=this._getFontSize(_8)+"%";}if(this.weightDifference){_c.style.fontWeight=this._getFontWeight(_8);}if(this.showTitle){_c.setAttribute("title",_9);}_c.setAttribute("href","javascript:"+this.clickFunction+"('"+_a+"')");_c.innerHTML=_9;dojo.place(_c,_b,"last");if(this.showCount){dojo.place(dojo.doc.createTextNode(" ("+_8+")"),_b,"last");}dojo.place(dojo.doc.createTextNode(" "),_6,"last");},this);},_getMaxMin:function(_d){dojo.forEach(_d,function(_e){var _f=parseInt(this.store.getValue(_e,this.countAttr));if((!this._tagMin)||(_f<this._tagMin)){this._tagMin=_f;}if((!this._tagMax)||(_f>this._tagMax)){this._tagMax=_f;}},this);this._slope=(this.fontMaxSize-this.fontMinSize)/(this._tagMax-this._tagMin);this._yintercept=(this.fontMinSize-((this._slope)*this._tagMin));this._weightSlope=(900-100)/(this._tagMax-this._tagMin);this._weightYIntercept=(100-((this._weightSlope)*this._tagMin));},_getFontWeight:function(_10){return 100*(Math.round(((this._weightSlope*_10)+this._weightYIntercept)/100));},_getFontSize:function(_11){return (this._slope*_11)+this._yintercept;}});}