### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ fdde144a-3cbd-4823-9986-2bca0cf18b48
begin
	import Pkg
	Pkg.activate(Base.current_project())
	using Orpheus
	init_score_render()
end

# ╔═╡ 7287f790-eb91-11ef-0b8d-39ce639f191e
# Copyright (c) [2025] [Yunoinsky Chen] All content in this repository is distributed under Mulan PSL v2. You can use this software according to the terms and conditions of the Mulan PSL v2. You may obtain a copy of Mulan PSL v2 at: http://license.coscl.org.cn/MulanPSL2 THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.See the Mulan PSL v2 for more details.

# ╔═╡ 71a52b10-b40e-4d4a-b2d7-ecf0c28d8936
md"""# Orpheus.jl - Music Notation in Pluto
It is easy to embed Orpheus' music notation in Pluto by using a EasyScore Canvas:
```julia
init_score_render()

ESCanvas(["G4/q, A4, B4, C5"])
```
"""

# ╔═╡ 30a92825-cfb1-4bfa-a951-ba6252fa34d1
ESCanvas(["G4/q, A4, B4, C5"])

# ╔═╡ 09cd6b61-4f99-487b-9180-8903e44d7a93
md"""
`ESCanvas` can be re-rendered in a different place than it was instantiated:
```julia
# Instantiating
es = ESCanvas(["G4/q, A4, B4, B4/r"]);

# Re-rendered in a tuple:
es_doublet = (es, es)
```
"""

# ╔═╡ b119b9e8-a1b3-497b-8a63-f8d3af7b4e84
es = ESCanvas(["G4/q, A4, B4, B4/r"]);

# ╔═╡ 08d84319-3391-4e8a-a598-02ea21bff7af
es_doublet = (es, es)

# ╔═╡ 8e548afd-ab8f-4b96-aee8-56043a332d72
md"""
## Voices
You may notice that, `ESCanvas` is instantiated with a vector of strings - each string represents a voice. The availabe number of voices varies from one to four:
```julia
two_voices = ESCanvas([
	"G4/q, A4, B4, A4", 
	"E4/h, D4"
])

three_voices = ESCanvas([
	"E5/q., D5/8, C5/q., A4/8", 
	"(E4 G4)/h, (F4 A4)", 
	"C4/h, C4"
])

four_voices = ESCanvas([
	"D5/h, C5",
	"F4/h, F4",
	"Bb3/h, A3",
	"D3/h, D#3"
])
```
"""

# ╔═╡ 4798806f-a36f-46c1-982a-7f7a1dd6cffd
two_voices = ESCanvas([
	"G4/q, A4, B4, A4", 
	"E4/h, D4"
])

# ╔═╡ 155fdca9-c6a8-4dd7-90e8-bb4b170c9cd0
three_voices = ESCanvas([
	"E5/q., D5/8, C5/q., A4/8", 
	"(E4 G4)/h, (F4 A4)", 
	"C4/h, C4"
])

# ╔═╡ 86bc1d08-7089-4983-bf02-02e8e7257e4b
four_voices = ESCanvas([
	"D5/h, C5",
	"F4/h, F4",
	"Bb3/h, A3",
	"D3/h, D#3"
])

# ╔═╡ 676e1493-b57d-4759-bbf3-4d3568ae4e2e
md"""
## String Literal for EasyScore
Orpheus.jl also provides an easy way to generate score with string literal. You can prefix the string with `es`, then the `@es_str` macro will automatically convert the string into an `ESCanvas`.
```julia
estr1 = es"A4/q, G4, F4/h"

typeof(estr1)
```
"""

# ╔═╡ 234efd33-f46a-49aa-a270-3e2bc573420b
estr1 = es"A4/q, G4, F4/h"

# ╔═╡ ffe783b1-9360-4894-8baa-cec1ac13fd18
md"""
The type of `estr1` is $(typeof(estr1))
"""

# ╔═╡ 16d162c4-9b8e-4aa4-ba3c-fc54aa6f85ae
md"""
Multiple voices can be written in a single `es_str` string seperated with `;` or `\n`(`<newline>`).
```julia
# in single line string:
es"D5/h, C5; F4/h, F4; Bb3/h, A3; D3/h, D#3"

# or in multiple line string:
es\"""
E5/q., D5/8, C5/q., A4/8
(E4 G4)/h, (F4 A4)
C4/h, C4
\"""
```
"""

# ╔═╡ bb8f49a5-7033-436a-9a4e-0f0371032193
singleline = es"D5/h, C5; F4/h, F4; Bb3/h, A3; D3/h, D#3"

# ╔═╡ b0904f0d-ea07-4a90-a8d8-a2d30bcaf0b6
multipleline = 
	es"""
	E5/q., D5/8, C5/q., A4/8
	(E4 G4)/h, (F4 A4)
	C4/h, C4
	"""

# ╔═╡ 3f6c60fc-67cc-4e95-b2e0-d0820ebad8ff
laterdefined = ESCanvas(["C4/q.., C4/16, B4/8/r, D4/q, E4/8"]);

# ╔═╡ bac0a43c-13cb-4168-91f8-4dec031764e8
md"""
## Embeded in Markdown or HTML
A ESCanvas is rendered as a SVG canvas by VexFlow, which means that you can easily embed it into Markdown blocks or other HTML elements in Pluto, just like this:
$(laterdefined)
You may notice that I've just cited a score defined at the end of this Notebook.

It's also allowed to create your score locally - this is really useful to keep some notes on music theory:

---
### II₇ → I₆:
$(es"(F4 A4 C5)/h, (E4 G4 C5); D4/h, E4")

---
### Fr⁺₆ → V
$(es\"""
	F#4/h, G4
	D4/w
	C4/h, B3
	Ab3/h, G3
	\""")

"""

# ╔═╡ Cell order:
# ╟─7287f790-eb91-11ef-0b8d-39ce639f191e
# ╟─fdde144a-3cbd-4823-9986-2bca0cf18b48
# ╟─71a52b10-b40e-4d4a-b2d7-ecf0c28d8936
# ╟─30a92825-cfb1-4bfa-a951-ba6252fa34d1
# ╟─09cd6b61-4f99-487b-9180-8903e44d7a93
# ╟─b119b9e8-a1b3-497b-8a63-f8d3af7b4e84
# ╟─08d84319-3391-4e8a-a598-02ea21bff7af
# ╟─8e548afd-ab8f-4b96-aee8-56043a332d72
# ╟─4798806f-a36f-46c1-982a-7f7a1dd6cffd
# ╟─155fdca9-c6a8-4dd7-90e8-bb4b170c9cd0
# ╟─86bc1d08-7089-4983-bf02-02e8e7257e4b
# ╟─676e1493-b57d-4759-bbf3-4d3568ae4e2e
# ╟─234efd33-f46a-49aa-a270-3e2bc573420b
# ╟─ffe783b1-9360-4894-8baa-cec1ac13fd18
# ╟─16d162c4-9b8e-4aa4-ba3c-fc54aa6f85ae
# ╟─bb8f49a5-7033-436a-9a4e-0f0371032193
# ╟─b0904f0d-ea07-4a90-a8d8-a2d30bcaf0b6
# ╟─bac0a43c-13cb-4168-91f8-4dec031764e8
# ╟─3f6c60fc-67cc-4e95-b2e0-d0820ebad8ff
