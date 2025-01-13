using Gtk;

public class Potato : Gtk.DrawingArea {
	Gdk.Texture texture;

	public Potato () {
		texture = Gdk.Texture.from_filename ("./drawing.svg");

		x = Random.double_range(1, 1920 - texture.get_width());
		y = Random.double_range(1, 1080 - texture.get_height());
		vx = Random.double_range(1, 5);
		vy = Random.double_range(1, 5);
		vr = Random.double_range(-180, 180);

		Timeout.add (10, () => {
			var movx = x + vx;
			var movy = y + vy;
			if (movx >= 1920 - texture.get_width() || movx <= 0)
				vx = -vx;
			else
				x = movx;
			if (movy >= 1080 - texture.get_height() || movy <= 0)
				vy = -vy;
			else
				y = movy;

			queue_draw ();
			return true;
		});
	}

	public override void snapshot (Gtk.Snapshot snapshot) {
		// Graphene.Vec4 color = {};
		// color.init (1.0f, 1.0f, 0.5f, 1.0f);

		// Graphene.Matrix matrix = {};
		// matrix.init_rotate (vr);
		// snapshot.push_color_matrix (matrix, color);
		snapshot.append_texture (texture, {{(int)x, (int)y}, {texture.get_width (), texture.get_height()}});
		// snapshot.pop ();
	}

	private double vr;
	private double vx;
	private double vy;
	private double x;
	private double y;
}


public class ExampleApp : Gtk.Application {
	public ExampleApp () {
		Object (application_id: "com.example.App");
	}

	public override void activate () {
		var win = new Gtk.ApplicationWindow (this) {
			decorated = false,
			maximized = true,
		};

		//provider

		var provider = new Gtk.CssProvider ();
		provider.load_from_data (css.data);
		Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);


		win.child = new Potato ();
		win.present ();
	}

	public static int main (string[] args) {
		var app = new ExampleApp ();
		return app.run (args);
	}
}

const string css = """
window {
	background-color: rgba(0,0,0,0.0)
}
""";
