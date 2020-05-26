extends Control


onready var voicebox: ACVoiceBox = $ACVoicebox


onready var conversation = [
    [$Label1, "Hey look, I've made this Animal Crossing style conversation player in Godot!", 4.0],
    [$Label2, "Wow, this would be great for placeholder dialogue sounds in my project! How can I use this?", 3.0],
    [$Label3, "Check out the instructions on the repo at https://github.com/mattmarch/ACVoicebox", 4.0],
    [$Label4, "Awesome, I'll have a look. Thanks a lot!", 3.0]
   ]


var current_label: Label


func _ready():
    voicebox.connect("characters_sounded", self, "_on_voicebox_characters_sounded")
    voicebox.connect("finished_phrase", self, "_on_voicebox_finished_phrase")
    play_next_in_conversation()


func _on_voicebox_characters_sounded(characters: String):
    current_label.text += characters


func _on_voicebox_finished_phrase():
    if conversation.size() > 0:
        play_next_in_conversation()
    

func play_next_in_conversation():
    var next_conversation = conversation.pop_front()
    current_label = next_conversation[0]
    voicebox.base_pitch = next_conversation[2]
    voicebox.play_string(next_conversation[1])
