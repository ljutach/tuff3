from rdflib import Graph, URIRef, Literal, BNode, Namespace
from rdflib.plugins.sparql import prepareQuery

def query_turtle_graph(graph, sparql_query):
    query = prepareQuery(sparql_query)
    results = graph.query(query)
    return results

def extract_local_name(uri):
    return uri.split("#")[-1]

def results_to_html_table(results):
    if not results:
        return "<p>No results found</p>"

    table_html = "<table border='1'><tr>"

    # Extracting column names
    columns = results.vars
    for column in columns:
        table_html += f"<th>{column}</th>"

    table_html += "</tr>"

    # Populating the table with data
    for result in results:
        table_html += "<tr>"
        for column in columns:
            cell_value = extract_local_name(result[column]) if isinstance(result[column], URIRef) else result[column]
            table_html += f"<td>{cell_value}</td>"
        table_html += "</tr>"

    table_html += "</table>"
    return table_html

# Example usage
tuff3_path = "/home/ljutach/Documents/unibo/DHDK_magistrale/courses/first_year/Knowledge_Representation_and_Extraction/tuff3/knowledge_base/tuff3.ttl"
output_html_file = "output23.html"

rdf_graph = Graph()
rdf_graph.parse(tuff3_path, format="turtle")

sparql_query = """
prefix t3: <http://www.semanticweb.org/ljutach/ontologies/2023/8/tuff3#>

SELECT ?explanandum ?reference
WHERE {
{
?explanandum t3:hasReference t3:comma_4 .
?explanandum t3:hasReference ?reference .
}
}
"""

results = query_turtle_graph(rdf_graph, sparql_query)

html_table = results_to_html_table(results)

with open(output_html_file, "w") as html_file:
    html_file.write(html_table)

print(f"HTML table saved to: {output_html_file}")
