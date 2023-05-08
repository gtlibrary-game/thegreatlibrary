from PIL import Image, ImageDraw, ImageFont

font = ImageFont.truetype("century-gothic.ttf", 25)
img = Image.open('book.png')
d1 = ImageDraw.Draw(img)


#token id
text = "0"
text_width, text_height = d1.textsize(text)
x = img.width - text_width - 58
y = img.height - text_height - 36
d1.text((x, y), text, fill=(255, 0, 0), font=font)


# Token Name
text = "Dracula"
text_width, text_height = d1.textsize(text)
x = 28
y = img.height - text_height - 36
d1.text((x, y), text, fill=(255, 0, 0), font=font)

img.save("book-0.png")
