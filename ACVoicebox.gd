extends AudioStreamPlayer
class_name ACVoiceBox

signal characters_sounded(characters)
signal finished_phrase()


const PITCH_MULTIPLIER_RANGE := 0.3
const INFLECTION_SHIFT := 0.4

export(float, 2.5, 4.5) var base_pitch := 3.5

const sounds = {
    'a': preload('res://Sounds/a.wav'),
    'b': preload('res://Sounds/b.wav'),
    'c': preload('res://Sounds/c.wav'),
    'd': preload('res://Sounds/d.wav'),
    'e': preload('res://Sounds/e.wav'),
    'f': preload('res://Sounds/f.wav'),
    'g': preload('res://Sounds/g.wav'),
    'h': preload('res://Sounds/h.wav'),
    'i': preload('res://Sounds/i.wav'),
    'j': preload('res://Sounds/j.wav'),
    'k': preload('res://Sounds/k.wav'),
    'l': preload('res://Sounds/l.wav'),
    'm': preload('res://Sounds/m.wav'),
    'n': preload('res://Sounds/n.wav'),
    'o': preload('res://Sounds/o.wav'),
    'p': preload('res://Sounds/p.wav'),
    'q': preload('res://Sounds/q.wav'),
    'r': preload('res://Sounds/r.wav'),
    's': preload('res://Sounds/s.wav'),
    't': preload('res://Sounds/t.wav'),
    'u': preload('res://Sounds/u.wav'),
    'v': preload('res://Sounds/v.wav'),
    'w': preload('res://Sounds/w.wav'),
    'x': preload('res://Sounds/x.wav'),
    'y': preload('res://Sounds/y.wav'),
    'z': preload('res://Sounds/z.wav'),
    'th': preload('res://Sounds/th.wav'),
    'sh': preload('res://Sounds/sh.wav'),
    ' ': preload('res://Sounds/blank.wav'),
    '.': preload('res://Sounds/longblank.wav')
}


var remaining_sounds := []


func _ready():
    connect("finished", self, "play_next_sound")


func play_string(in_string: String):
    parse_input_string(in_string)
    play_next_sound()


func play_next_sound():
    if len(remaining_sounds) == 0:
        emit_signal("finished_phrase")
        return
    var next_symbol = remaining_sounds.pop_front()
    emit_signal("characters_sounded", next_symbol.characters)
    # Skip to next sound if no sound exists for text
    if next_symbol.sound == '':
        play_next_sound()
        return
    var sound: AudioStreamSample = sounds[next_symbol.sound]
    # Add some randomness to pitch plus optional inflection for end word in questions
    pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf()) + (INFLECTION_SHIFT if next_symbol.inflective else 0.0)
    stream = sound
    play()


func parse_input_string(in_string: String):
    for word in in_string.split(' '):
        parse_word(word)
        add_symbol(' ', ' ', false)
    

func parse_word(word: String):
    var skip_char := false
    var is_inflective := word[-1] == '?'
    for i in range(len(word)):
        if skip_char:
            skip_char = false
            continue
        # If not the last letter, check if next letter makes a two letter substring, e.g. 'th'
        if i < len(word) - 1:
            var two_character_substring = word.substr(i, i+2)
            if two_character_substring.to_lower() in sounds.keys():
                add_symbol(two_character_substring.to_lower(), two_character_substring, is_inflective)
                skip_char = true
                continue
        # Otherwise check if single character has matching sound, otherwise add a blank character
        if word[i].to_lower() in sounds.keys():
            add_symbol(word[i].to_lower(), word[i], is_inflective)
        else:
            add_symbol('', word[i], false)


func add_symbol(sound: String, characters: String, inflective: bool):
    remaining_sounds.append({
        'sound': sound,
        'characters': characters,
        'inflective': inflective
    })
