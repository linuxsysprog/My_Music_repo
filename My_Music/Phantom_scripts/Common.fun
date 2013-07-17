# a blocking System() call
function void _System(string cmd, window win) {
	_System_(cmd, win, 90);
}

function void _System_(string cmd, window win, int max_secs) {
	exception err;
	
	if (Exists(win)) {
		err.SetError(cmd + " is already running");
		err.throw();
	}
	
	System(cmd);

	for (int i = 0; i < max_secs; i++) {
		if (Exists(win)) {
			disp(cmd + " started");
			return;
		}
		
		disp("Waiting for " + cmd + " to start")
		Sleep(1);
	}
	
	err.SetError(cmd + " failed to start on time");
	err.throw();
}

