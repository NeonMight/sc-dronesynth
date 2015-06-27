//Audio components
s.boot; //boot the audio device (same as Server.local.boot)

(
SynthDef.new(\sine,
	{
		arg freq = 440, lfreq=10, cut=1000;
		var lfosc = SinOsc.kr(lfreq,0,1,0);
		var sig = SinOsc.ar(freq*lfosc,0,1,0); //ar means audio signal
		sig = LPF.ar(sig,cut,1,0); //simple lowpass filter
		Out.ar(0, sig); //left speaker
		Out.ar(1, sig); //right speaker
}).add;
) //parens allow for evaluation of entire block (multiple lines)

(
SynthDef.new(\saw,
	{
		arg freq = 440, lfreq=10, cut=1000;
		var lfosc = SinOsc.kr(lfreq,0,1,0);
		var sig = Saw.ar(freq*lfosc,1,0);
		sig = LPF.ar(sig,cut,1,0) //lowpass filter
		Out.ar(0, sig); //left
		Out.ar(1, sig); //right
}).add;
)
x = Synth.new(\sine); //instantiate new synth based on synth def
x.free; //free synth to stop audio

s.quit; //stop audio device

//GUI components
(
Window.closeAll;
a = Window.new("Drone Synth", Rect(200,200,500,250));
a.front;
a.alwaysOnTop = true;
)

(
var butt = Button(a,Rect(20,20,50,30)); //on/off button for audio signal
butt.states = [["Off",Color.black,Color.white],["On",Color.white,Color.black]];
butt.action = //new anonymous function
{
	arg obj;
	if (obj.value == 1,{~x = Synth.new(\sine);},{~x.free}); //control structure to handle button state
};
)

(
var ptc = Knob(a,Rect(80,20,35,35));
ptc.action =
{
	arg obj;
	var val = obj.value.linexp(0,1,200,1000).postln;
	~x.set(\freq, val); //set the frequency to the value of the freq knob
};
)

(
var lf = Knob(a,Rect(140,20,35,35));
lf.action =
{
	arg obj;
	var val = obj.value.linexp(0,1,0.1,20).postln;
	~x.set(\lfreq, val);
}
)

(
var coff = Knob(a,Rect(200,20,35,35));
coff.action =
{
	arg obj;
	var val = obj.value.linexp(0,1,100,2500).postln;
	~x.set(\cut,val);
}
)

var freqlabel = StaticText(a,Rect(80,60,60,20));
freqlabel.string = "Freq";

var lfolabel = StaticText(a, Rect(140,60,60,20));
lfolabel.string = "LFO";

var cutofflabel = StaticText(a,Rect(200,60,60,20));
cutofflabel.string = "Cutoff";

a.close;