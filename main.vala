
internal const string WALLPAPER = "/tmp/patator.png";
internal int WIDTH;
internal int HEIGHT;

class Patate {
	public Patate(Cairo.ImageSurface texture) {
		this.texture = texture;

		x = Random.double_range(1, WIDTH - texture.get_width());
		y = Random.double_range(1, HEIGHT - texture.get_height()); 
		vx = Random.double_range(1, 10);
		vy = Random.double_range(1, 10);
		vr = Random.double_range(-180, 180);
	}

	public void draw(Cairo.Context ctx) {
		var movx = x + vx;
		var movy = y + vy;
		if (movx >= WIDTH - texture.get_width() || movx <= 0)
			vx *=-1;
		else
			x = movx;
		if (movy >= HEIGHT - texture.get_height() || movy <= 0)
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

		for (int i = 0; i < 30; i++)
			tab += new Patate(patate);

		base.key_press_event.connect((event) => {
				string keyval = Gdk.keyval_name(event.keyval);
				print("%s\n", keyval);
				if (keyval == "Escape")
					Gtk.main_quit();
				return false;
		});
		area.draw.connect((ctx) => {
			ctx.set_source_surface(image, 0, 0);
			ctx.paint();

			foreach (var p in tab)
				p.draw(ctx);
			return false;
		});

		var timeout = new TimeoutSource(10);

		timeout.set_callback(()=> {
			area.queue_draw();
			return true;
		});

		timeout.attach(GLib.MainContext.default());

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
    var win = Gdk.get_default_root_window();
    var screen = Gdk.Screen.get_default();

    WIDTH = screen.get_width();
    HEIGHT = screen.get_height();
    Gdk.Pixbuf screenshot = Gdk.pixbuf_get_from_window(win, 0, 0, WIDTH, HEIGHT);
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
