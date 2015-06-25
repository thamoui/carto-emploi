/*
 * [ango] functions.js
 */

//Affiche les markers reçu par la requete Ajax
function getMarker(response) {
    clearMarkers();

    //Boucle sur les emplois reçus
    $.each(response, function (i) {

        //récupération des informations
        var title = response[i].title;
        var contrat_type = response[i].contrat_type;
        var region_adress = response[i].region_adress
        var url = response[i].url;
        var latitude = response[i].latitude;
        var longitude = response[i].longitude;

        var tabDescription = [region_adress, contrat_type, "<a href='" + url + "' target=\"_blank\">Voir le lien de l'offre</a>"];
        var txtDescription = tabDescription.join("<br>");

        //Création du marker
        var myIcon = L.icon({iconUrl: "/img/curseur-ango-1_360.png", "iconSize": [50, 50], "iconAnchor": [25, 25]});
        
        var marker = L.marker(new L.LatLng(latitude, longitude), {
            icon: myIcon,
            title: title
        });
        marker.bindPopup(title+"<br>"+txtDescription);
        markers.addLayer(marker);

        //Ajout du groupe de marker sur la map
        map.addLayer(markers);
    });
}


//Requete ajax pour récupérer les emplois autour du centre de la carte
function getMarkerCenter(distance, limit, page, searchtxt) {
    var coordinates = map.getCenter();

    $.ajax({
        type: 'GET',
        url: '/geosearch/' + coordinates.lat + ',' + coordinates.lng + '?d=' + distance + '&limit=' + limit + '&p=' + page + '&text=' + searchtxt,
        crossDomain: true,
        dataType: 'json',
        contentType: "application/json",
        success: function (response) {
            if (response.length <= 0) {
                alert_map("Aucune offre d'emploi ne correspond à votre recherche");
            } else {
                alert_map("");
                getMarker(response);
            }
        }
    });
}

//Requete ajax pour récupérer les labels des emplois
function getJobs() {
    $.ajax({
        type: 'GET',
        url: '/metiers', 
        crossDomain: true,
        dataType: 'json',
        contentType: "application/json",
        success: function(response) {
            $.each(response, function(i) {
                var label = response[i].label;
                $("#jobs").append("<option value='" +label+ "'>" + label + "</option>");
            });
        }
    });
}

//Appel de la fonction getJobs
getJobs();

//Affiche la zone recherche
function showMap(err, data) {
    // The geocoder can return an area, like a city, or a
    // point, like an address. Here we handle both cases,
    // by fitting the map bounds to an area or zooming to a point.
    if (data.latlng) {
        map.setView([data.latlng[0], data.latlng[1]], 10);
    }
}

//Remise à zero des markers
function clearMarkers() {
    map.removeLayer(markers);
    markers.clearLayers();
}

//Message d'alerte
function alert_map(msg) {
    document.getElementById("msg-alert").innerHTML = msg;
}

//Popup ouvrante
function popupIn() {
    document.getElementById("popup_band").style.display='block';
    document.getElementById("popup_text").style.display='block';
    document.getElementById("popup_cordage").style.display='block';
}

//Popup fermante
function popupOut() {
    document.getElementById("popup_band").style.display='none';
    document.getElementById("popup_text").style.display='none';
    document.getElementById("popup_cordage").style.display='none';
}
