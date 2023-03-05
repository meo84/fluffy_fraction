require 'rvg/rvg'
include Magick

RVG::dpi = 90

a = 4
X_A = 170*2
Y_A = 200*2 + 100
b = 3
X_B = 515*2 + 60
Y_B = 400*2 + 200
FONT_SIZE = 40*1.5
FONT_FAMILY = 'chalkduster'
RADIUS = 60*3
GIF_DIMENSION = 12
VIEWPORT_WIDTH = 1600
VIEWPORT_HEIGHT = 1000
FRAMES_COUNT = 200
ALPHA = 2


gif = ImageList.new

def get_abs(position:, value:, frame:)
  position + RADIUS * Math.cos(ALPHA * value * frame * Math::PI / FRAMES_COUNT)
end

def get_ord(position:, value:, frame:)
  position + RADIUS * Math.sin(ALPHA * value * frame * Math::PI / FRAMES_COUNT)
end

def fade_in(i)
  case i
  when 0..9
    0.01
  when 10..12
    0.1
  when 13..15
    0.5
  when 16..18
    0.7
  else
    1
  end
end

def add_text(title:, text:, color:, opacity:)
  title.tspan(text).styles(font_size: FONT_SIZE, font_family: FONT_FAMILY, fill: color, fill_opacity: opacity)
end

def draw_a(canvas, a, opacity)
  canvas.background_fill = 'black'

  canvas.text(68*2, Y_A - RADIUS - 20) do |title|
    add_text(title: title, text: "When x makes #{a}", color: 'white', opacity: opacity)
  end

  canvas.text(X_A - RADIUS - 70, Y_A) do |title|
    add_text(title: title, text: "R             unds,", color: 'white', opacity: opacity)
  end
end

def draw_b(canvas, b, opacity)
  canvas.text(X_B - RADIUS - 430, Y_B) do |title|
    add_text(title: title, text: "y makes #{b} R             unds,", color: 'white', opacity: opacity)
  end
end

def draw_a_over_b(canvas, a, b, i)
  opacity_one = case i
  when 0..59
    0
  when 60..62
    0.1
  when 63..65
    0.5
  when 66..68
    0.7
  else
    1
  end

  canvas.text(420*2, -10*2 - 50) do |title|
    add_text(title: title, text: "And that is (wh)y", color: 'white', opacity: opacity_one)
  end

  opacity_two = case i
  when 0..119
    0
  when 120..122
    0.1
  when 123..125
    0.5
  when 126..128
    0.7
  else
    1
  end

  canvas.text(420*2 - 100, 55*2 - 50) do |title|
    add_text(title: title, text: "x/y kinda looks like", color: 'white', opacity: opacity_two)
  end

  opacity_this = case i
  when 0..189
    0
  when 190..192
    0.1
  when 193..195
    0.5
  when 196..198
    0.7
  else
    1
  end
  canvas.text(420*2 + 200, 120*2 - 50) do |title|
    add_text(title: title, text: 'this', color: 'turquoise', opacity: opacity_this)
  end
end

20.times do |i|
  rvg_intro = RVG.new(GIF_DIMENSION.cm, GIF_DIMENSION.cm).viewbox(0,0,VIEWPORT_WIDTH,VIEWPORT_HEIGHT)
  gif << rvg_intro.draw
end

70.times do |i|
  rvg_a = RVG.new(GIF_DIMENSION.cm, GIF_DIMENSION.cm).viewbox(0,0,VIEWPORT_WIDTH,VIEWPORT_HEIGHT) do |canvas|
    opacity = case i
    when 0..49
      0.01
    when 50..52
      0.1
    when 53..55
      0.5
    when 56..58
      0.7
    else
      1
    end
    draw_a(canvas, a, opacity)

    abs = get_abs(position: X_A, value: a, frame: i)
    ord = get_ord(position: Y_A, value: a, frame: i)
    canvas.g.translate(abs, ord) do |a_circle|
      a_circle.circle(20).styles(fill: 'blue')
    end
  end

  gif << rvg_a.draw
end

30.times do |i|
  rvg_b = RVG.new(GIF_DIMENSION.cm, GIF_DIMENSION.cm).viewbox(0,0,VIEWPORT_WIDTH,VIEWPORT_HEIGHT) do |canvas|
    draw_a(canvas, a, 1)

    abs = get_abs(position: X_A, value: a, frame: i + 70)
    ord = get_ord(position: Y_A, value: a, frame: i + 70)
    canvas.g.translate(abs, ord) do |a_circle|
      a_circle.circle(20).styles(fill: 'blue')
    end

    draw_b(canvas, b, fade_in(i))

    abs_b = get_abs(position: X_B, value: b, frame: i + 70)
    ord_b = get_ord(position: Y_B, value: b, frame: i + 70)
    canvas.g.translate(abs_b, ord_b) do |b_circle|
      b_circle.circle(20).styles(fill: 'green')
    end
  end

  gif << rvg_b.draw
end

FRAMES_COUNT.times do |i|
  rvg_ab = RVG.new(GIF_DIMENSION.cm, GIF_DIMENSION.cm).viewbox(0,0,VIEWPORT_WIDTH,VIEWPORT_HEIGHT) do |canvas|
    draw_a(canvas, a, 1)

    abs = get_abs(position: X_A, value: a, frame: i + 100)
    ord = get_ord(position: Y_A, value: a, frame: i + 100)
    canvas.g.translate(abs, ord) do |a_circle|
      a_circle.circle(20).styles(fill: 'blue')
    end

    draw_b(canvas, b, 1)

    abs_b = get_abs(position: X_B, value: b, frame: i + 100)
    ord_b = get_ord(position: Y_B, value: b, frame: i + 100)
    canvas.g.translate(abs_b, ord_b) do |b_circle|
      b_circle.circle(20).styles(fill: 'green')
    end

    draw_a_over_b(canvas, a, b, i)

    canvas.line(abs,ord, abs_b,ord).styles(fill: 'blue')
    canvas.line(abs_b,ord_b, abs_b,ord).styles(fill: 'green')

    i.times do |n|
      abs_b_n = get_abs(position: X_B, value: b, frame: n + 100)
      ord_a_n = get_ord(position: Y_A, value: a, frame: n + 100)
      canvas.g.translate(abs_b_n, ord_a_n) do |ab_circle|
        ab_circle.circle(0.5).styles(fill: 'turquoise')
      end
    end
  end

  gif << rvg_ab.draw
end

gif.iterations = 1
gif.write('fluffy_fraction.gif')
