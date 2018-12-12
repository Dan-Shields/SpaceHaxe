import parts.*;

class Game extends hxd.App {

    public static var gravity = 1.5;
    
    public static var width = 1280;
    public static var height = 720;

    var floor : Floor;
    var ship : Ship;

    public var debugGraphics : h2d.Graphics;

    var debugText : h2d.Text;

    override function init() {

        s2d.setFixedSize(width, height);

        debugGraphics = new h2d.Graphics(s2d);
        debugGraphics.x = width / 2;
        debugGraphics.y = height / 2;

        debugText = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        debugText.x = debugText.y = 5;

        floor = new Floor(s2d);
        ship = new Ship(s2d);
    }

    override function update(dt:Float) {

        #if !release
        debugGraphics.clear();

        debugText.text = Std.string(dt * 1000).substr(0, 4) + 'ms';
        debugText.text += '\n' + Std.string(hxd.Timer.fps()).substr(0, 4) + 'fps';
        #end

        // Update entities
        floor.update();
        ship.update(dt);

        // Red ship = no collision, yellow ship = collision
        if (floor.detectCollision(ship.verticies)) {
            ship.objColor = 0xffdd0e;
            ship.ySpeed = 0;
            ship.xSpeed += ship.xSpeed < 0 ? 0.5 : -0.5;
        } else {
            ship.objColor = 0xe30613;
        }
    }

    public static var inst : Game;

    static function main() {
        inst = new Game();
    }
}
