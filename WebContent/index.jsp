<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.ArrayList"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name='viewport'
	content='initial-scale=1,maximum-scale=1,user-scalable=no' />

<title>hotelMap</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.5.1/dist/leaflet.css"
	integrity="sha512-xwE/Az9zrjBIphAcBb3F6JVqxf46+CDLwfLMHloNu6KEQCAWi6HcDUbeOfBIptF7tcCzusKFjFw2yuvEpDL9wQ=="
	crossorigin="" />
<link rel="stylesheet"
	href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css"
	crossorigin="" />
<link rel="stylesheet"
	href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"
	crossorigin="" />
<!-- <link href='https://api.mapbox.com/mapbox.js/v3.2.0/mapbox.css'
	rel='stylesheet' />
 -->

<script src="https://unpkg.com/leaflet@1.5.1/dist/leaflet.js"
	integrity="sha512-GffPMF3RvMeYyc1LWMHtK8EbPv0iNZ8/oTtHPx9/cc2ILxQ+u905qIwdpULaqDkyBKgOaB57QTMg7ztg8Jm2Og=="
	crossorigin=""></script>
<script
	src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"
	crossorigin=""></script>
<!--<script src='https://api.mapbox.com/mapbox.js/v3.2.0/mapbox.js'></script>-->



<style>
#mapid {
	height: 900px;
	width: 1600px;
}
</style>



</head>
<body>
	<center>
		<div id="mapid"></div>
	</center>
	<%
		ArrayList<String> lng = new ArrayList<String>();
		ArrayList<String> lat = new ArrayList<String>();

		ArrayList<String> name = new ArrayList<String>();
		ArrayList<String> adress = new ArrayList<String>();
		ArrayList<String> avg_score = new ArrayList<String>();

		//foooTest
		
		Connection myConn = null;
		Statement myStmt = null;
		ResultSet myRs = null;
		String url = "jdbc:mysql://localhost:3306/adv-programming?serverTimezone=UTC";
		String user = "root";
		String pass = "root";
		try {
			myConn = DriverManager.getConnection(url, user, pass);
			System.out.println("Database connection successful! \n");
			myStmt = myConn.createStatement();
			myRs = myStmt.executeQuery("select * from hotel");
			while (myRs.next()) {
				//out.write(myRs.getString("Reviewer_Nationality"));
				//out.write("lat: "+myRs.getString("lat")+" long: "+myRs.getString("lng")+System.lineSeparator());
				lng.add(myRs.getString("lng"));
				lat.add(myRs.getString("lat"));

				String hotel_name = myRs.getString("Hotel_Name");
				hotel_name = ("'" + hotel_name + "'");
				name.add(hotel_name);
				String hotel_adress = myRs.getString("Hotel_Adress");
				hotel_adress = ("'" + hotel_adress + "'");
				adress.add(hotel_adress);
				avg_score.add(myRs.getString("Average_Score"));
			}
		}

		catch (Exception exc) {
			exc.printStackTrace();
		} finally {
			if (myRs != null) {
				myRs.close();
			}
			if (myStmt != null) {
				myStmt.close();
			}
			if (myConn != null) {
				myConn.close();
			}
		}
	%>

	<script type="text/javascript" charset="UTF-8">
	
	//L.mapbox.accessToken = 'pk.eyJ1IjoiZGljdGk5MyIsImEiOiJjandnaGppOGsxaDFzM3pwbDN0a2JrZHJhIn0.Mhb_8xkh5BCZPM4ERfJXUA';
	
	var mymap = L.map('mapid').setView([ 48.864716, 2.349014 ], 6);//.addLayer(L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v11'));
	
	
//	myFeatureLayer.on('click', function(e) {
 //       mymap.panTo(e.layer.getLatLng())});
	
	L
	.tileLayer(
	'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
	{
	attribution : "",
	maxZoom : 18,
	id : 'mapbox.streets',
	accessToken : 'pk.eyJ1Ijoia3B0bmphY2siLCJhIjoiY2p3OG1mMm0xMDM3dTQ5a2J2eGs4cW90ZSJ9.FKSkPQzaDT_A36UdXBAARg'
	}).addTo(mymap);
	
var array_length = parseInt("<%=lng.size()%>
		");

		var lng =
	<%=lng%>
		var lat =
	<%=lat%>
		var hotel_name =
	<%=name%>
		var hotel_adress =
	<%=adress%>
		var avg_score =
	<%=avg_score%>
		var hotels = L.layerGroup();
		var markers = L.markerClusterGroup();

		for (var i = 0; i < array_length; i++) {
			var marker = L.marker([ lat[i], lng[i] ]);

			markers.addLayer(L.marker([ lat[i], lng[i] ]).bindPopup(
					"<b>" + hotel_name[i] + "</b><br>Adress: "
							+ hotel_adress[i] + "</b><br>Score: "
							+ avg_score[i]));

			markers.addTo(mymap);

		}

		markers.addTo(hotels);

		var overlayMaps = {
			"Hotels" : hotels
		};

		L.control.layers(null, overlayMaps).addTo(mymap);

		//	var myFeatureLayer = L.mapbox.featureLayer('/mapbox.js/assets/data/sf_locations.geojson')
		//   .addTo(mymap)
	</script>
</body>
</html>