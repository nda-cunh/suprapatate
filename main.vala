
internal const string WALLPAPER = "/tmp/patator.png";

class Patate {
	public Patate(Cairo.ImageSurface texture) {
		this.texture = texture;
		x = Random.double_range(50, 1000);
		y = Random.double_range(50, 1000);
		vx = Random.double_range(0, 10);
		vy = Random.double_range(0, 10);
		vr = Random.double_range(-180, 180);
	}

	public void draw(Cairo.Context ctx) {
		var movx = x + vx;
		var movy = y + vy;
		if (movx >= 1800 || movx <= 0)
			vx *=-1;
		else
			x = movx;
		if (movy >= 1000 || movy <= 0)
			vy *=-1;
		else
			y = movy;


		ctx.set_source_surface(texture, x, y);
		ctx.paint();
	}

	private Cairo.ImageSurface texture;
	private double vr;
	private double vx;
	private double vy;
	private double x;
	private double y;
}

class Render : Gtk.Window {
	public Render() {
		this.image = new Cairo.ImageSurface.from_png (WALLPAPER);
		this.patate = new Cairo.ImageSurface.from_png(Environment.get_home_dir() + "/.local/share/patate.png");
		this.area = new Gtk.DrawingArea();

		Patate []tab = {};

		for (int i = 0; i < 20; i++)
			tab += new Patate(patate);

		area.draw.connect((ctx) => {
			ctx.set_source_surface(image, 0, 0);
			ctx.paint();

			foreach (var p in tab)
				p.draw(ctx);
			area.queue_draw();
			return false;
		});

		base.add(area);
		base.destroy.connect(Gtk.main_quit);
		base.fullscreen();
		base.show_all();
	}

	private Cairo.ImageSurface image;
	private Cairo.ImageSurface patate;
	private Gtk.DrawingArea area;
}

void screen_window() {
	int  width, height;
    Gdk.Window win = Gdk.get_default_root_window();

    width = win.get_width();
    height = win.get_height();
    Gdk.Pixbuf screenshot = Gdk.pixbuf_get_from_window(win, 0, 0, width, height);
	try {
		screenshot.save(WALLPAPER ,"png");
	}
	catch (Error e) {
		printerr(e.message);
	}
}

int	main(string []args)
{
	Gtk.init(ref args);
	screen_window();
	new Render();
	Gtk.main();
	return (0);
}
