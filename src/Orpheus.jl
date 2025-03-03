# Copyright (c) [2025] [Yunoinsky Chen] All content in this repository is distributed under Mulan PSL v2. You can use this software according to the terms and conditions of the Mulan PSL v2. You may obtain a copy of Mulan PSL v2 at: http://license.coscl.org.cn/MulanPSL2 THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.See the Mulan PSL v2 for more details.
module Orpheus

export ESCanvas, @es_str, init_score_render

import HypertextLiteral: @htl, JavaScript

const _vexf_ver = v"4.2.2"
const _vexf_cdn = "https://cdn.jsdelivr.net/npm/vexflow@$_vexf_ver/build/cjs/vexflow.js"

function init_score_render()
    @htl("""<script src = "$_vexf_cdn"></script>""")
end

"an easyscore canvas with text content for 1~4 voices"
struct ESCanvas
	"Voice Strings, in EasyScore format"
	voices::Vector{String}
end

function Base.show(io::IO, m::MIME"text/html", sc::ESCanvas)
	show(io, m, render(sc))
end

function render(sc::ESCanvas)
	function voice_snippet(estext, clef)
        "score.voice(score.notes('$estext', {clef: '$clef'}))"    
    end    
	function voice_snippet(estext, clef, stem)
		"score.voice(score.notes('$estext', {clef: '$clef', stem: '$stem'}))"
	end
	function stave_snippet(estexts, clef)
		"""
		system.addStave({
			voices: [
				$(
				if length(estexts) == 1
					voice_snippet(estexts[1], clef)
				else
					"""
					$(voice_snippet(estexts[1], clef, "up")),
					$(voice_snippet(estexts[2], clef, "down"))
					"""
				end)
			]
		}).addClef('$clef').addTimeSignature('C');
		"""
	end
	unique_id = string(rand(UInt32),base=16)
	staves, height = 
		if length(sc.voices) ≤ 2 
			stave_snippet(sc.voices, "treble"), 150
		else 
			stave_snippet(sc.voices[1:2], "treble")* 
			stave_snippet(sc.voices[3:end], "bass"), 260	
		end
	expr = JavaScript("""
		var vf = new Vex.Flow.Factory({renderer: {elementId: '$unique_id', width: 300, height:$height}});
		var score = vf.EasyScore();
		var system = vf.System();
		$(staves)
		system.addConnector();
		vf.draw();
	""")

	return @htl """
	<div id="$unique_id"></div>	
	<script>$expr</script>
	"""
end

macro es_str(easytext)
	esvector = 
		split(easytext, c -> c =='\n'||c==';') |> 
		filter(x -> x ≠ "") .|> lstrip
	ESCanvas(esvector)
end

end