include "Common.fun";

use "Transcribe.dec";
use "Audio.dec";
use "Export.dec";

SetDelay(600);

# load program
try {
	_System("Transcribe", Transcribe_);
} catch (exception e) {
	disp(e.GetMessage());
	exit;
}

# load wav file
Transcribe_.TypeKeys("<CTRL-o>");
Transcribe_.TypeKeys(filename + ".wav");
Transcribe_.TypeKeys("<ENTER>");

# adjust speed
Transcribe_.MouseClick(0, 630, 40, 0);
Audio.MouseClick(2, 300, 200, 0);
Audio.TypeKeys("a");
Audio.TypeKeys(rate);
Audio.Close();

# export wav file
Transcribe_.TypeKeys("<ALT-f>");
Transcribe_.TypeKeys("e");
Export.MouseClick(2, 300, 315, 0);
Export.TypeKeys("a");
Export.TypeKeys(filename + "." + rate + ".wav");
Export.TypeKeys("<ENTER>");
Sleep(30);

# close program
Transcribe_.Close();
Transcribe_.TypeKeys("<TAB>");
Transcribe_.TypeKeys("<ENTER>");

