# Script for ES 7 deployment and loading of indices.
# There are 3 groups of commands:

# SSH to a dedicated VM for the ES 7 sever in order to run the container:
sudo -s
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.17.18
docker network create elastic
docker run --name es01 --net elastic -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.17.18

# Install necessary dictionaries inside the container:
docker exec -it es01 bash
# Enters container
apt update
apt install git
cd /usr/share/elasticsearch/config
git clone https://github.com/itvaleriy/elasticsearch-hunspell-dictionaries
mv elasticsearch-hunspell-dictionaries/ hunspell

# Load data from your local machine:
git clone 
cd transformed_data
# Server healthcheck (IP address may vary)
curl 34.106.10.253:9200 
# Create indices, settings and mapping
curl -X PUT http://34.106.10.253:9200/ua_keywords/
curl -d @ua_keywords.settings.json -H "Content-Type: application/json" -X PUT http://34.106.10.253:9200/ua_keywords/_settings
curl -d @ua_keywords.mapping.json -H "Content-Type: application/json" -X PUT http://34.106.10.253:9200/ua_keywords/_mapping
# Reindex documents from file to the new index
curl -d @ua_keywords.json -H "Content-Type: application/json" -X PUT http://34.106.10.253:9200/ua_keywords/_bulk
# Check if indices are loaded ok
curl -X GET "34.106.10.253:9200/_cat/indices/" 
