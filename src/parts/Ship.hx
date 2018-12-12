package parts;

import hxd.Key;
import h2d.col.Point;

class Ship extends ConvexPolygon {

	var acc = 3;

	var spinSpeed = 0.;
	public var xSpeed = 0.0;
	public var ySpeed = 0.;

	public function new(parent : h2d.Object) {
		width = 25.;
		height = 25.;

		// Generate triangle
		points = [new Point(-width / 2, -height / 2), new Point(0, height / 2), new Point(width / 2, -height / 2)];

		super(parent);

		x = Game.width * 0.2;
		y = Game.height * 0.2;
		rotation = Math.PI;

		objColor = 0xffffff;

		solid = false;
	}

	public function update(dt : Float) {
		var deltaRot = 0.;

		// Gravity
        ySpeed += Game.gravity;

		// Rotation
		if (Key.isDown(Key.A)) deltaRot -= 1.5;
		if (Key.isDown(Key.D)) deltaRot += 1.5;
		
		// Acceleration - based off last frame's rotation
		if (Key.isDown(Key.SPACE)) {
            xSpeed += acc * Math.sin(rotation - Math.PI);
            ySpeed -= acc * Math.cos(rotation - Math.PI);
        }

		#if !release
		if (Key.isDown(Key.W)) {
            x += dt * 50 * Math.sin(rotation - Math.PI);
            y -= dt * 50 * Math.cos(rotation - Math.PI);
        }

		if (Key.isDown(Key.BACKSPACE)) {
			xSpeed = 0;
			ySpeed = 0;
		}
		#end

		// Update pos & rot
		rotation += dt * deltaRot;
		x += 		dt * xSpeed;
		y += 		dt * ySpeed;

		updateFinish();
	}
}
 