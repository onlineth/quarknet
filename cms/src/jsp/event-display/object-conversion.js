function makePoint(array) {
	return {x: array[0], y: array[1], z: array[2]};
}

function makePoint2(x, y, z) {
	return {x: x, y: y, z: z};
}

function addPoints(p1, p2) {
	return {x: p1.x + p2.x, y: p1.y + p2.y, z: p1.z + p2.z};
}

function subPoints(p1, p2) {
	return {x: p1.x - p2.x, y: p1.y - p2.y, z: p1.z - p2.z};
}

function add(a1, a2) {
	return [a1[0] + a2[0], a1[1] + a2[1], a1[2] + a2[2]];
}

function makeColor(base, opacity) {
	return new Pre3d.RGBA(base[0], base[1], base[2], base[3] * opacity);
}

function distance(p1, p2) {
	var dx = p1.x - p2.x;
	var dy = p1.y - p2.y;
	var dz = p1.z - p2.z;
	return Math.sqrt(dx * dx + dy * dy + dz * dz);
}

function pointToStr(p) {
	return "x: " + p.x + ", y: " + p.y + ", z: " + p.z;
}

function affineToStr(m) {
	  return "[[" + m.e0 + ", " + m.e1 + ", " + m.e2  + ", " + m.e3  + "], " + 
	  		  "[" + m.e4 + ", " + m.e5 + ", " + m.e6  + ", " + m.e7  + "], " + 
	  		  "[" + m.e8 + ", " + m.e9 + ", " + m.e10 + ", " + m.e11 + "]]";
}

function makeTrack(data) {
	log("makeTrack(" + data + ")");
	return {p1: makePoint(data[0]), p2: makePoint(add(data[0], data[1]))};
}

function makeHit(data) {
	return makePoint(data[0]);
}

function makeSiStripDigis(data) {
	return makePoint(data[1]);
}

function makeCSCWD(data) {
	//[pos:p3d, len:num, ...]
	var crds = data[0];
	//this looks like a "line" tangent to a circle on the detector axis
	var x = crds[0];
	var y = crds[1];
	var z = crds[2];
	var l = data[1];
	var da = Math.sqrt(x * x + y * y);
	var sc = l / da / 2;
	var dx = x * sc;
	var dy = y * sc;
	 
	return {p1: makePoint2(x - dy, y + dx, z), p2: makePoint2(x + dy, y - dx, z)};
}

function makeCSCSD(data) {
	//[pos:p3d, len:num, ...]
	var crds = data[0];
	//radial to detector axis
	var x = crds[0];
	var y = crds[1];
	var z = crds[2];
	var l = data[1];
	var da = Math.sqrt(x * x + y * y);
	var sc = l / da / 2;
	var dx = x * sc;
	var dy = y * sc;
	 
	return {p1: makePoint2(x - dx, y - dy, z), p2: makePoint2(x + dx, y + dy, z)};
}

function makeQuad(f1, f2, f3, f4, b1, b2, b3, b4, fill, stroke) {
	var s = new Pre3d.Shape();
    s.vertices = [
      f1, f2, f3, f4, b1, b2, b3, b4
    ];

    //    4 -- 0
    //   /|   /|     +y
    //  5 -- 1 |      |__ +x
    //  | 7 -|-3     /
    //  |/   |/    +z
    //  6 -- 2

    s.quads = [
      new Pre3d.QuadFace(0, 1, 2, 3),  // Front
      new Pre3d.QuadFace(4, 5, 6, 7),  // Back
      //new Pre3d.QuadFace(0, 1, 5, 4),
      //new Pre3d.QuadFace(2, 4, 7, 6),
      //new Pre3d.QuadFace(1, 2, 6, 5),
      //new Pre3d.QuadFace(0, 3, 7, 4),
    ];
    //s.rects = [[f1, f2, f3, f4], [b1, b2, b3, b4]];
    s.lines = [{v1: 0, v2: 4}, {v1: 1, v2: 5}, {v1: 2, v2: 6}, {v1: 3, v2: 7}];
    // much faster to draw lines instead of the 4 faces
    s.fillColor = fill;
    s.strokeColor = stroke;

    Pre3d.ShapeUtils.rebuildMeta(s);
    return s;
}

function makeRecHits(data, rd, descr) {
	//["energy", "double"],["eta", "double"],["phi", "double"],["detid", "int"],
	//["front_1", "v3d"],["front_2", "v3d"],["front_3", "v3d"],["front_4", "v3d"],["back_1", "v3d"],["back_2", "v3d"],["back_3", "v3d"],["back_4", "v3d"]
	return makeQuad(makePoint(data[4]), makePoint(data[5]), makePoint(data[6]), makePoint(data[7]),
			makePoint(data[8]), makePoint(data[9]), makePoint(data[10]), makePoint(data[11]), 
			makeColor(descr.fill, getRankValue(data, rd) * 0.8 + 0.2),
			makeColor(descr.color, getRankValue(data, rd) * 0.8 + 0.2));
}

function makeSimpleRecHits(data, rd, descr) {
	var s = new Pre3d.Shape();
    s.vertices = [makePoint(data[4]), makePoint(data[5]), makePoint(data[6]), makePoint(data[7])];
    s.quads = [new Pre3d.QuadFace(0, 1, 2, 3)];
    s.fillColor = makeColor(descr.fill, getRankValue(data, rd) * 0.8 + 0.2);
    s.strokeColor = makeColor(descr.color, getRankValue(data, rd) * 0.8 + 0.2);

    Pre3d.ShapeUtils.rebuildMeta(s);
    return s;
}

function makeCaloTowers(data, rd, descr) {
	//["et", "double"],["eta", "double"],["phi", "double"],["iphi", "double"],["hadEnergy", "double"],["emEnergy", "double"],
	//["pos", "v3d"],
	//["front_1", "v3d"],["front_2", "v3d"],["front_3", "v3d"],["front_4", "v3d"],["back_1", "v3d"],["back_2", "v3d"],["back_3", "v3d"],["back_4", "v3d"]
	var f1 = makePoint(data[7]);
	var f2 = makePoint(data[8]);
	var f3 = makePoint(data[9]);
	var f4 = makePoint(data[10]);
	var b1 = makePoint(data[11]);
	var b2 = makePoint(data[12]);
	var b3 = makePoint(data[13]);
	var b4 = makePoint(data[14]);
	
	return makeQuad(f1, f2, f3, f4, b1, b2, b3, b4, 
			makeColor(descr.fill, getRankValue(data, rd) * 0.8 + 0.2),
			makeColor(descr.color, getRankValue(data, rd) * 0.8 + 0.2));
}

var MAX_JET_LENGTH = 4; 
	
function makeJet(data, rd, descr) {
	var et = data[0];
	var theta = data[2];
	var phi = data[3];
	var l = MAX_JET_LENGTH * getRankValue(data, rd);
	log("l: " + l);
	var cone = Pre3d.ShapeUtils.makeCone(l, l / 6, 24);
	var t = new Pre3d.Transform();
	log("theta: " + theta*360/2/3.141 + ", phi: " + phi*360/2/3.141);
	t.rotateY(theta);
	t.rotateZ(phi);
	
	var v = new Array();
	for (var i = 0; i < cone.vertices.length; i++) {
		v.push(t.transformPoint(cone.vertices[i]));
	}
	cone.vertices = v;
	cone.fillColor = makeColor(descr.color, 0.4);
	cone.strokeColor = null;
	Pre3d.ShapeUtils.rebuildMeta(cone);
	return cone;
}

function makeDTDigis(data) {
	//["wireNumber", "int"],["layerId", "int"],["superLayerId", "int"],["sectorId", "int"],["stationId", "int"],["wheelId", "int"],
	//["pos", "v3d"],["axis", "v3d"],["angle", "double"],
	//["countsTDC", "int"],["number", "int"],
	//["cellWidth", "double"],["cellLength", "double"],["cellHeight", "double"]]
	var pos = makePoint(data[6]);
	var axis = makePoint(data[7]);
	var len = data[12];
	var angle = data[8];
	var t = new Pre3d.Transform();
	t.rotateAroundAxis(axis, angle);
	var p1 = t.transformPoint(makePoint2(0, - len / 2, 0));
	var p2 = t.transformPoint(makePoint2(0, len / 2, 0));
	
	return {p1: addPoints(pos, p1), p2: addPoints(pos, p2)};
}

function makeDTRecHits(data) {
	//["wireId", "int"],["layerId", "int"],["superLayerId", "int"],["sectorId", "int"],["stationId", "int"],["wheelId", "int"],
	//["digitime", "double"],
	//["wirePos", "v3d"],
	//["lPlusGlobalPos", "v3d"],["lMinusGlobalPos", "v3d"],["rPlusGlobalPos", "v3d"],["rMinusGlobalPos", "v3d"],
	//["lGlobalPos", "v3d"],["rGlobalPos", "v3d"],
	//["axis", "v3d"],["angle", "double"],["cellWidth", "double"],["cellLength", "double"],["cellHeight", "double"]]
	var pos = makePoint(data[7]);
	var axis = makePoint(data[14]);
	var angle = data[15];
	var len = data[17];
	
	var t = new Pre3d.Transform();
	t.rotateAroundAxis(axis, angle);
	var p1 = t.transformPoint(makePoint2(0, - len / 2, 0));
	var p2 = t.transformPoint(makePoint2(0, len / 2, 0));
	
	return {p1: addPoints(pos, p1), p2: addPoints(pos, p2)};
}

function makeDTRecSegments(data) {
	return {p1: makePoint(data[1]), p2: makePoint(data[2])};
}

function makeRPCRecHits(data) {
	return [{p1: makePoint(data[0]), p2: makePoint(data[1])}, 
	        {p1: makePoint(data[2]), p2: makePoint(data[3])}, 
	        {p1: makePoint(data[4]), p2: makePoint(data[5])}];
}

function firstPoint(assoc, data2) {
	for (var i = 0; i < assoc.length; i++) {
		var asi = assoc[i];
		if (asi[0][1] == 0) {
			return makePoint(data2[asi[1][1]][0]);
		}
	}
} 

function makeTrackPoints(data, rd, descr, data2, assoc) {
	//"PFBrems_V1": [["deltaP", "double"],["sigmadeltaP", "double"]] (spec - tracks)
	//"PFBremTrajectoryPoints_V1": [[[43, 0], [42, 25]], (assoc)
	//[[43, 0], [42, 26]], 
	//[[43, 0], [42, 27]], 
	//[[43, 0], [42, 28]],
	//[collectionId, objectId]
	//"PFTrajectoryPoints_V1": [["pos", "v3d"],["dir", "v3d"]] (other - points)
	
	// man, that took me a while
	// so the association is of form [[[_, i], [_, p]]...]
	// where i represents an index into the data array and p represents an index
	// into the track points array
	// to build a track, one needs to add all the points with indices p for which 
	// i is equal to the current index into data
	
	if (!assoc) {
		throw "No association for " + descr.key;
	}
	var a = new Array();
	for (var i = 0; i < data.length; i++) {
		var last = null;
		for (var j = 0; j < assoc.length; j++) {
			if (assoc[j][0][1] == i) {
				var p = makePoint(data2[assoc[j][1][1]][0]);
				if (last !== null) {
					a.push({p1: last, p2: p});
				}
				last = p;
			}
		}
	}
	return a;
}

/*
 * 
 * 
"GsfTrackExtras_V1": [[[37, 0], [38, 0]], 
[[37, 1], [38, 1]]
]

"TrackExtras_V1": [[[2, 0], [3, 0]], 
[[2, 1], [3, 1]]
]

"Extras_V1": [[[0.0401944, -0.0103354, -0.0174814], [923.289, -238.174, 738.918], [1.05821, -0.273628, 0.797378], [917.889, -238.014, 734.835]], 
[[-0.0401818, 0.0104068, -0.0818134], [-955.721, 246.517, -765.15], [-1.03381, 0.266071, -0.877191], [-963.512, 247.307, -771.153]]
]

"GsfExtras_V1": [[[0.0401958, -0.0103279, -0.0174892], [1864.99, -481.33, 1492.84], [1.05821, -0.273637, 0.797469], [649.777, -168.58, 520.271]], 
[[-0.0401819, 0.0104067, -0.0818068], [-1209.66, 311.983, -968.486], [-1.03381, 0.266067, -0.877252], [-680.918, 174.709, -545.014]]
]
 */

/**
 * This ignores control points. I'm not sure what iSpy does, but
 * my curves are visibly curved in some cases when they appear as straight lines
 * in iSpy
 */
function makeTrackPoints2(data, rd, descr, data2, assoc) {
	if (!assoc) {
		throw "No association for " + descr.key;
	}
	
	var lines = new Array();
	
	for (var i = 0; i < data.length; i++) {
		var last = null;
		for (var j = 0; j < assoc.length; j++) {
			if (assoc[j][0][1] == i) {
				var mapped = data2[assoc[j][1][1]];
				var pos1 = makePoint(mapped[0]);
				var pos2 = makePoint(mapped[2]);
				log(descr.key + ": " + pointToStr(pos1) + ", " + pointToStr(pos2));
				if (last !== null) {
					lines.push({p1: last, p2: pos1});
				}
				lines.push({p1: pos1, p2: pos2});
				last = pos2;
			}
		}
	}
	return lines;
}

function makeTrackCurves(data, rd, descr, data2, assoc) {
	if (!assoc) {
		throw "No association for " + descr.key;
	}
	
	var paths = new Array();
	
	for (var i = 0; i < data.length; i++) {
		//var last = null;
		var cnt = 0;
		var path = new Pre3d.Path();
		var points = new Array();
		var curves = new Array();
		for (var j = 0; j < assoc.length; j++) {
			if (assoc[j][0][1] == i) {
				var mapped = data2[assoc[j][1][1]];
				var pos1 = makePoint(mapped[0]);
				var dir1 = Pre3d.Math.normalize(makePoint(mapped[1]));
				var pos2 = makePoint(mapped[2]);
				var dir2 = Pre3d.Math.normalize(makePoint(mapped[3]));
				log("pos1 = " + pointToStr(Pre3d.Math.normalize(subPoints(pos2, pos1))) + ", dir1 = " + pointToStr(dir1) + "pos2 = " + pointToStr(pos2) + ", dir2 = " + pointToStr(dir2));
				points.push(pos1);
				points.push(dir1);
				points.push(pos2);
				points.push(dir2);
				curves.push(new Pre3d.Curve(cnt * 4 + 2, cnt * 4 + 1, cnt * 4 + 3)); 
				cnt++;
			}
		}
		path.points = points;
		path.curves = curves;
		path.starting_point = 0;
		paths.push(path);
	}
	return paths;
}

function makeTrackCurves2(data, rd, descr, data2, assoc) {
	if (!assoc) {
		throw "No association for " + descr.key;
	}
	
	var l = new Array();
	
	for (var i = 0; i < data.length; i++) {
		for (var j = 0; j < assoc.length; j++) {
			if (assoc[j][0][1] == i) {
				var mapped = data2[assoc[j][1][1]];
				var pos1 = makePoint(mapped[0]);
				var dir1 = addPoints(Pre3d.Math.normalize(makePoint(mapped[1])), pos1);
				var pos2 = makePoint(mapped[2]);
				var dir2 = addPoints(Pre3d.Math.normalize(makePoint(mapped[3])), pos1); 
				l.push({p1: pos1, p2: pos2, d1: dir1, d2: dir2});
			}
		}
	}
	return l;
}

function getRankingData(d_event, desc, data) {
	if (!desc.rank) {
		return null;
	}
	var tdata = d_event["Types"][desc.key];
	var index = null;
	for (var i = 0; i < tdata.length; i++) {
		if (desc.rank = tdata[i][0]) {
			index = i;
			break;
		}
	}
	if (index === null) {
		throw "Invalid rank for " + desc.key + ": " + desc.rank;
	}
	var v = new Array();
	var indices = new Array();
	for (var i = 0; i < data.length; i++) {
		var vv = data[i][index];
		if (vv == null) {
			log("Invalid " + desc.rank + " for " + desc.key + "[" + i + "]");
		}
		v.push(vv);
		indices.push([vv, i]);
	}
	v.sort();
	indices.sort(function(a, b) { return a[0] - b[0] });
	var dataOrder = new Array();
	for (var i = 0; i < indices.length; i++) {
		dataOrder.push(indices[i][1]);
	}
	var range = v[v.length - 1];
	var thresholdIndex = Math.round(v.length * GLOBAL_RANK_THRESHOLD);
	var rd = {
		index: index,
		sorted: v,
		dataOrder: dataOrder,
		range: range,
		dirty: true,
		lowCut: document.settings.globalCaloEnergyLowCut,
		highCut: 1.0,
	};
	log("ranking for " + desc.key + ": index = " + index + ", range = " + range + ", v = " + v.length);
	return rd;
}

function rebuildRankingIndices(rd) {
	rd.lowIndex = findIndex(rd.sorted, rd.lowCut * rd.range);
	rd.highIndex = findIndex(rd.sorted, rd.highCut * rd.range) + 1;
	rd.dirty = false;
}

function findIndex(vec, value) {
	for (var i = 0; i < vec.length; i++) {
		if (vec[i] >= value) {
			return i;
		}
	}
}

function getRankValue(data, rd) {
	if (rd) {
    	return data[rd.index] / rd.range;
    }
	else {
		return null;
	}
} 