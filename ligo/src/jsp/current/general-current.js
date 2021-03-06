/*
 * EPeronja-04/15/2013: Made a copy of the existing general.js in /bluestone
 * 						This will work with the current data and we might need to modify the code 
 * 						so left the original code for the legacy data.
 */
var data = []; 
var timeout = 30000; /* Some data takes awhile to load; 30sec should be enough?  */ 
var dataPoints = 1200; 
var dataServerUrl = "/elab/ligo/data/data-server-json-current.jsp";
var plotViewerURL = "/elab/ligo/plots/view.jsp";
var plot = null; 
var placeholder = null; 

var xminGPSTime;
var xmaxGPSTime; 

var ligoMinTime; 
var ligoMaxTime; 
var ligoMaxRange; 

var hasBeenPlotted = false; 

var options = { 
	lines: {show: true, lineWidth: 1, shadowSize: 0 },
	points: {show: false},
	legend: {show: true},
	xaxis: { mode: 'time'},
	selection: { mode: "x" },
	shadowSize: 0,
	colors: ["#7192ca", "#e0964b", "#84ba5b", "#d25d5f", "#959798", "#cbc173", "#8862a5"]
};

var calendarParam = {
	showOn: 'button', 
	buttonImage: '../graphics/calendar-blue.png',
	buttonImageOnly: true, 
	changeMonth: true,
	changeYear: true, 
	showButtonPanel: true,
	dateFormat: 'D M dd yy',
	minDate: new Date(2003, 3-1, 5),
	maxDate: new Date(),
	onSelect: datePickerSelected
};

ln = function(v) { return v > 0 ? Math.log(v) : 0; }
exp = function(v) { return Math.exp(v); }

function spinnerOn() {
	$("#busySpinner").css('visibility', 'visible');
}

function spinnerOff() {
	$("#busySpinner").css('visibility', 'hidden');
}

function smallSpinnerOn() {
	$("#busySpinnerSmall").css('visibility', 'visible');
}

function smallSpinnerOff() {
	$("#busySpinnerSmall").css('visibility', 'hidden');
}

function convertTimeGPSToUNIX(x) { 
	// TODO: Make a proper offset, this is off depending on leap seconds
	return x + 315964787.0;
}

function convertTimeUNIXtoGPS(x) {
	return x - 315964787.0;
}

function zoomButtonSet() {
	if (hasBeenPlotted) {
		$("#buttonZoomOut").removeAttr("disabled");
	}
}

function datePickerSelected(dateText, inst) {
	//EPeronja-03/20/2013: Added null check
	if (plot != null) {
		plot.clearSelection(false);
	}
	var d = new Date(inst.currentYear, inst.currentMonth, inst.currentDay, 0, 0, 0)
	
	if (inst.id == "xmin") {
		xminGPSTime = convertTimeUNIXtoGPS(d.getTime() / 1000);
	}
	else if (inst.id == "xmax") {
		xmaxGPSTime = convertTimeUNIXtoGPS(d.getTime() / 1000);
	}
}

function centerElement(id) {
	var el = $("#" + id);
	el.css("left", ((window.innerWidth - el.width()) / 2) + "px");
	el.css("top", ((window.innerHeight - el.height()) / 2) + "px");
}

$(document).ready(function() {
	$('.datepicker').datepicker(calendarParam);
	$("#xmin").datepicker('option', 'buttonText', 'Choose start date.');
	$("#xmax").datepicker('option', 'buttonText', 'Choose end date.');
	$('img.ui-datepicker-trigger').css('vertical-align', 'text-bottom'); 
	
	placeholder = $("#chart");
	
	$.plot(placeholder, { }, options);
	//$("#slider").slider();

	$("#resizablecontainer").resizable(); 
	
	// Get maximum timespan to start
	$.ajax({
		url: dataServerUrl + '?fn=getTimeRange', 
		method: 'GET',
		dataType: 'json', 
		timeout: 10000,
		success: onTimeRangeReceived,
		beforeSend: spinnerOn,
		complete: onTimeRangeCompleted
	});
	
	function onTimeRangeReceived(series) {
		xminGPSTime = series.minTime; 
		ligoMinTime = series.minTime; 
		xmaxGPSTime = series.maxTime; 
		ligoMaxTime = series.maxTime;
		$("#xmin").val((new Date(convertTimeGPSToUNIX(parseFloat(xminGPSTime)) * 1000.0)).toDateString()); 
		$("#xmax").val((new Date(convertTimeGPSToUNIX(parseFloat(xmaxGPSTime)) * 1000.0)).toDateString());
		//console.log(document.getElementById("xmin").value);
		//console.log(document.getElementById("xmax").value);		
		ligoMaxRange = ligoMaxTime - ligoMinTime; 

		$("#slider").slider( { min: 0, max: 1200, value: 600} );
		
		//getDataAndPlotCB();
	}

	function onTimeRangeCompleted() {
		spinnerOff();
	}

	placeholder.bind("plotselected", function(event, ranges) {
		xminGPSTime = convertTimeUNIXtoGPS(ranges.xaxis.from / 1000.0); 
		xmaxGPSTime = convertTimeUNIXtoGPS(ranges.xaxis.to / 1000.0); 
		$("#buttonZoom").removeAttr("disabled");
	});
	
	placeholder.bind("plotunselected", function(event) {
		$("#buttonZoom").attr("disabled", "true");
	});

	$("#parseDropDown").click(function() {
		var c = $("#channelSelector :selected").val();
		if (c == "placeholder") {
			return;
		}
		//console.log("getdataparms: " + c);
		var url = dataServerUrl + '?fn=getData&params=' + c + ',0,' + xminGPSTime + ',' + xmaxGPSTime;

		// Get the data via AJAX call
		$.ajax({
			url: url,
			method: 'GET', 
			dataType: 'text',
			timeout: timeout,
			success: onChannelDataReceived,
			beforeSend: spinnerOn,
			complete: spinnerOff
		});

		function onChannelDataReceived(series) { 
			//console.log("series: " + series);
			var s = series.split(" ");
			var a = new Array();
			var num = s[0];
			for (var i = 0; i < s.length / 2 - 1; i++) {
				a.push([convertTimeGPSToUNIX(parseFloat(s[i * 2 + 1])) * 1000.0, s[i * 2 + 2]]);
			}
			data = [{data: a, shadowSize: 0}];
			//console.log("data: " + data);
			plot = $.plot(placeholder, data, options); 

			updateSliderPositionCB(plot); 
		}
	});

	$("#resizablecontainer").bind("resizestop", function(event, ui) {
		$("#chart").css('width', ui.size.width - 8);
		$("#chart").css('height', ui.size.height - 8);
		if (plot != null) {
			$.plot(placeholder, data, options);  
		}
		
	});

	function updateSliderPositionCB(plot) {
		$("#slider").css('margin-left', plot.getPlotOffset().left + 'px');
		
		// resize slider
		// remember, x-axis values are in UNIX millis time, not GPS second time! 
		
		// get width of the slider control
		var sliderWidth = $("#slider").width(); 
		var currentViewWidth = (plot.getAxes().xaxis.max - plot.getAxes().xaxis.min) / 1000.0;
		var currentViewWidthMaxRatio = currentViewWidth / ligoMaxRange; 
		var newSliderWidth = parseInt(sliderWidth * currentViewWidthMaxRatio);
		var newSliderOffset = parseInt(newSliderWidth / -2.0);
		$(".ui-slider .ui-slider-handle").css('width', newSliderWidth + 'px'); 
		$(".ui-slider .ui-slider-handle").css('margin-left', newSliderOffset + 'px'); 

		// move position to new place on slider (SHOULD start out centered!) 
		// Slider range is 0-1200
		//var currentViewMiddle = convertTimeUNIXtoGPS((plot.getAxes().xaxis.max - plot.getAxes().xaxis.min) / 2.0);
		var currentXMax = plot.getAxes().xaxis.min/1000.0;
		var currentXMin = plot.getAxes().xaxis.max/1000.0;
		var currentXCenter = (currentXMax + currentXMin) / 2.0; 
		var currentViewPosition = (convertTimeUNIXtoGPS(currentXCenter) - ligoMinTime) / ligoMaxRange * 1200.0;
		 
		// alter slider
		$("#slider").slider("option", "value", currentViewPosition);
	}
	
});