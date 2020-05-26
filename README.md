# Godot Animal Crossing Voicebox

I discovered [this Youtube video by Equalo where he makes an Animal Crossing style voice generator in Python](https://youtu.be/RYnI_ZLj5ys) and wanted to adapt it to GDScript as a fun placeholder dialogue audio system when making games with [Godot Engine](https://godotengine.org/).

The letter sounds are taken from [his animalese-generator repo here](https://github.com/equalo-official/animalese-generator).

Checkout [this Reddit post](https://www.reddit.com/r/godot/comments/gqyhal/i_created_a_gdscript_animal_crossing_style/) to see a video of it in action!


## Usage
1. Add ACVoicebox.tscn to your scene.
2. To read a string aloud pass it like `$ACVoicebox.play_string('Your example string!')`
3. The pitch can be varied by setting `$ACVoicebox.base_pitch` between 2.5 and 4.5.
4. The `characters_sounded` signal is emitted with the spoken characters as an argument when each sound is made, it can be used to make letters appear on the screen as the dialogue is spoken.
5. The `finished_phrase` signal is emitted once all the characters have been spoken.


## Improvements
* Use [AudioEffectPitchShift](https://docs.godotengine.org/en/stable/classes/class_audioeffectpitchshift.html) to vary the pitch rather than `pitch_scale` in `AudioStreamPlayer` so that we don't speed up/slow down the dialogue when changing pitch. 
