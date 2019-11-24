import html2text

html=open("pap.htm", "r").read()
text=html2text.html2text(html)
file_w=open("pap.txt", "w")
html_w.write(text)