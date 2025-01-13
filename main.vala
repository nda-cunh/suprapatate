using Gtk;

public class Potato : Gtk.DrawingArea {
	Gdk.Texture texture;
	public Potato () {
		texture = Gdk.Texture.from_filename ("./patate.png");
	}

	public override void snapshot (Gtk.Snapshot snapshot) {
		snapshot.append_texture (texture, {{0, 0}, {texture.get_width (), texture.get_height()}});
	}
}


public class ExampleApp : Gtk.Application {
	public ExampleApp () {
		Object (application_id: "com.example.App");
	}

	public override void activate () {
		var win = new Gtk.ApplicationWindow (this);
		win.maximize ();

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
