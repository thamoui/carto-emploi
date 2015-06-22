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
        var marker = L.marker(new L.LatLng(latitude, longitude), {
            icon: L.mapbox.marker.icon({'marker-symbol': 'suitcase', 'marker-color': '#ED1450'}),
            title: title,
            description: txtDescription
        });
        marker.bindPopup(title);
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

//Remise à zero des markers
function clearMarkers() {
    map.removeLayer(markers);
    markers.clearLayers();
}

//Message d'alerte
function alert_map(msg) {
    document.getElementById("msg-alert").innerHTML = msg;
}
