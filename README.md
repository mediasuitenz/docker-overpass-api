# docker-overpass-api

OpenStreetMap Docker for [Overpass API](http://wiki.openstreetmap.org/wiki/Overpass_API).

## Building the Docker image

Download a OSM file in XML format compressed in bzip format and save as `planet.osm.bz2`. [Geofabrik](http://download.geofabrik.de/) is an excellent resource for this.

```
curl -o planet.osm.bz2 http://download.geofabrik.de/australia-oceania/new-zealand-latest.osm.bz2
docker build -t mediasuite/overpass-api .
```

## Running the Docker image

`docker run -p 81:81 overpass-api`

## Example

Get all ways that have a highway key value near [-36.9162, 174.8310](http://www.openstreetmap.org/?mlat=-36.91616249427225&mlon=174.831023812294&zoom=16) in JSON format.

**Overpass QL**

```
[out:json][timeout:25];
(
  way
  (
    around:15,-36.9162,174.8310
  )
  ["highway"];
  ._;>;
);
out;
```

<http://localhost/api/interpreter?data=%5Bout:json%5D%5Btimeout:25%5D;(way(around:15,-36.91616249427225,174.831023812294)%5B%22highway%22%5D;._;%3E;);out;>

## Troubleshoot
- If error code is related to code 137 then it indicates process is killed due to the out of memery. Either start with smaller osm file, maybe for a smaller region, or change docker settings for the memory usage.
- If error is related to no directory is found then this can be due to the blank characters in any of the file in windows. So, run `dos2unix.exe` on all 4 files (i.e. *Dockerfile , overpass, nginx.conf, docker-start)*