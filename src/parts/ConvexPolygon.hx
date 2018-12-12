package parts;

import h2d.col.Point;
import h3d.Vector;

class ConvexPolygon extends h2d.Graphics {
	// Verticies relative to object origin
	var points : Array<Point>;

	// Verticies relative to scene origin
	public var verticies : Array<Vector>;

	var width : Float;
	var height : Float;

	public var objColor : Int;

	public var solid = true;

	public function new(parent : h2d.Object) {
		super(parent);

		verticies = vectorsFromPoints(points);
	}

	function updateFinish() {
		// Recalc vertex positions
		verticies = vectorsFromPoints(points);

		// Draw
		clear();

		lineStyle(1, objColor, 1);

		if (solid) { 
			beginFill(objColor);
		}
		
		var lastPoint = points[points.length - 1];
		moveTo(lastPoint.x, lastPoint.y);

		for (point in points) {
			lineTo(point.x, point.y);
		}
	}

	function vectorsFromPoints(points : Array<Point>) : Array<Vector> {
		var vectors : Array<Vector> = [];
		for (point in points) {
			var global = localToGlobal(point.clone());
			vectors.push(new Vector(global.x, global.y));
		}
		return vectors;
	}

	/**
	 * Collision functions
	 */

	public function detectCollision(testObj : Array<Vector>) : Bool {

        // Test both objects against obj1 axes first, then obj2
        return doProjectionsOverlap(this.verticies, testObj) && doProjectionsOverlap(testObj, this.verticies);
    }

    function doProjectionsOverlap(baseObj : Array<Vector>, testObj : Array<Vector>) : Bool {

        var axes : Array<Float> = [];

        for (i in 0...(baseObj.length - 1)) {
            var edgeVector = baseObj[i].sub(baseObj[i+1]);
            axes.push(getPerpAngle(edgeVector));
        }

        // Edge from last to first vertex
        var lastEdgeVector = getPerpAngle(baseObj[baseObj.length - 1].sub(baseObj[0]));
        axes.push(lastEdgeVector);

        for (axis in axes) {
            var baseProjectionRange = projectToAxis(axis, baseObj);
            var testProjectionRange = projectToAxis(axis, testObj);

            // Test if the two objects overlap when projected onto the created axis
            if (!(baseProjectionRange['max'] >= testProjectionRange['min'] && testProjectionRange['max'] >= baseProjectionRange['min'])) {
                // Return as soon as the objects don't overlap on one axis
                return false;
            }
        }
        
        // Objects overlap on all tested axes
        return true;
    }

    function projectToAxis(axisAngle : Float, verticies : Array<Vector>) : Map<String, Float> {

        var values : Array<Float> = [];

        // Loop through object verticies and calc angle of position vector relative to y axis
        for (vertex in verticies) {
            // Calculate angle of position vector
            var vertexVectorAngle = Math.atan2(vertex.x, vertex.y) + (3/2 * Math.PI);

            // Add the value of where the vertex lies on the axis when projected onto it
            values.push(Math.cos(axisAngle - vertexVectorAngle) * vertex.length());
        }
        
        #if !release
        // Draw axis line
        Game.inst.debugGraphics.lineStyle(1, 0xfff000, 1);
        Game.inst.debugGraphics.moveTo(Game.width * -2 * Math.cos(axisAngle), Game.width * -2 * Math.sin(axisAngle));
        Game.inst.debugGraphics.lineTo(Game.width * 2 * Math.cos(axisAngle), Game.width * 2 * Math.sin(axisAngle));
        #end

        // Establish the range of values the whole object covers when projected onto the specified axis
        var min = Math.POSITIVE_INFINITY;
        var max = Math.NEGATIVE_INFINITY;

        for (val in values) {
            min = val < min ? val : min;
            max = val > max ? val : max;
        }

        return ["min" => min, "max" => max];
    }


    static inline function getPerpAngle(edge : Vector) : Float {
        return (Math.PI * 2) - Math.atan2(edge.x, edge.y);
    }
}