package parts;

import h2d.col.Point;

class Floor extends ConvexPolygon {
	public function new(parent : h2d.Object) {
		width = Std.int(Game.width * 1.1);
        height = Std.int(Game.height / 10);

		points = [new Point(0, 0), new Point(width, 0), new Point(width, height), new Point(0, height)];

		super(parent);

		x = Game.width * -0.1;
		y = Game.height * 0.9;

		objColor = 0xffffff;
	}

	public function update() {
		updateFinish();
	}
}
