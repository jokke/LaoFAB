
import java.io.IOException;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;

import org.apache.solr.client.solrj.request.AbstractUpdateRequest;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.request.ContentStreamUpdateRequest;
import org.apache.solr.common.params.ModifiableSolrParams;
import org.apache.solr.handler.extraction.ExtractingParams;
import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


import java.util.*;
//import java.util.Map;
//import java.util.TreeMap;

public class SolrIndexer {

	public static void main(String args[]) {
		try {
			indexFilesSolrCell(args[0]);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	private static void indexFilesSolrCell(String fileName) 
		    throws Exception {
		ModifiableSolrParams p = new ModifiableSolrParams();
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		Document doc = dBuilder.parse(new File(fileName));
		doc.getDocumentElement().normalize();

		String root_node = doc.getDocumentElement().getNodeName();
		
		NodeList docNodes = doc.getElementsByTagName("doc");

		String urlString = "http://localhost:8080/solr"; 
		SolrServer solr = new HttpSolrServer(urlString);

		ContentStreamUpdateRequest up = new ContentStreamUpdateRequest("/update/extract");
		Map<String, Collection<String>> map = new HashMap<String, Collection<String>>();

		for (int j = 0; j < docNodes.getLength(); j++) {
			Element docElement = (Element) docNodes.item(j);
			NodeList nodes = docElement.getChildNodes();
			for (int i = 0; i < nodes.getLength(); i++) {
				Node node = nodes.item(i);
				if (node.getNodeType() != Node.ELEMENT_NODE)
					continue;
				if (node.getNodeName() != "field")
					continue;

				Element element = (Element) node;
				String fieldtype = element.getAttributeNode("name").getValue();
				if (fieldtype.equalsIgnoreCase("file")) {
					up.addFile(new File(node.getTextContent()));
					continue;
				}
//				if (element.getAttributeNode("multi").getValue().equals("true")) {
//					Collection<String> values = map.get(fieldtype);
//					if (values==null) {
//						values = new ArrayList<String>();
//						map.put(fieldtype, values);
//					}
//					values.add(node.getTextContent());
//					continue;
//				}
					

				if (fieldtype.equalsIgnoreCase("id")) {
					//up.setParam("literal.id", node.getTextContent());
					p.add(ExtractingParams.LITERALS_PREFIX + "id", node.getTextContent());
					continue;
				}
				//up.setParam("literal.doc_"+fieldtype, node.getTextContent());
				p.add(ExtractingParams.LITERALS_PREFIX + "doc_" + fieldtype, node.getTextContent());
			}
		}

/*		Iterator<String> iter = map.keySet().iterator();
		while (iter.hasNext()) {
			String fieldtype = iter.next();
			Collection<String> values = map.get(fieldtype);
			for (String value : values) {
System.out.println("Setting "+fieldtype+" to "+value);
				p.add(ExtractingParams.LITERALS_PREFIX + "doc_" + fieldtype, value);
			}
			//up.setParams(p);
		} */

		//up.setParam("uprefix", "attr_");
		//up.setParam("fmap.content", "attr_content");
		p.add("uprefix", "attr_");
		p.add("fmap.content", "attr_content");
		up.setParams(p);
		up.setAction(AbstractUpdateRequest.ACTION.COMMIT, true, true);
		solr.request(up);
//		QueryResponse rsp = solr.query(new SolrQuery("*:*"));
//		System.out.println(rsp);
	}
}


