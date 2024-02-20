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
# Server healthcheck (IP address may vary)
curl http://34.106.10.253:9200 
# Create indices, settings and mapping, be in the right path with all the files from customer
curl -XPUT http://34.106.10.253:9200/serpstat_ua_ads/
curl -XPOST http://34.106.10.253:9200/serpstat_ua_ads/ads/  -H "Content-Type: application/json" --data-binary @ua_ads_definition.json
curl -XPOST http://34.106.10.253:9200/serpstat_ua_ads/ads/_bulk  -H "Content-Type: application/json" --data-binary @serpstat_ua_ads.json

curl -XPUT http://34.106.10.253:9200/serpstat_ua_keywords/
curl -XPOST http://34.106.10.253:9200/serpstat_ua_keywords/keywords/  -H "Content-Type: application/json" --data-binary @ua_keywords_definition.json
curl -XPOST http://34.106.10.253:9200/serpstat_ua_keywords/keywords/_bulk  -H "Content-Type: application/json" --data-binary @serpstat_ua_keywords.json

curl -XPUT http://34.106.10.253:9200/serpstat_ua_positions/
curl -XPOST http://34.106.10.253:9200/serpstat_ua_positions/positions/  -H "Content-Type: application/json" --data-binary @ua_positions_definition.json
curl -XPOST http://34.106.10.253:9200/serpstat_ua_positions/positions/_bulk  -H "Content-Type: application/json" --data-binary @serpstat_ua_positions.json

curl -XPUT http://34.106.10.253:9200/serpstat_ua_rating/
curl -XPOST http://34.106.10.253:9200/serpstat_ua_rating/rating/  -H "Content-Type: application/json" --data-binary @ua_rating_definition.json
curl -XPOST http://34.106.10.253:9200/serpstat_ua_rating/rating/_bulk  -H "Content-Type: application/json" --data-binary @serpstat_ua_rating.json

curl -XPUT http://34.106.10.253:9200/serpstat_ua_suggestions/
curl -XPOST http://34.106.10.253:9200/serpstat_ua_suggestions/suggestions/  -H "Content-Type: application/json" --data-binary @ua_suggestions_definition.json
curl -XPOST http://34.106.10.253:9200/serpstat_ua_suggestions/suggestions/_bulk  -H "Content-Type: application/json" --data-binary @serpstat_ua_suggestions.json

# Check if indices are loaded ok
curl -X GET "34.106.10.253:9200/_cat/indices/" 
