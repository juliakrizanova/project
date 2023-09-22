import tkinter as tk
# Library used to open applications
import AppOpener

# Create Object
root = tk.Tk()

# Set geometry
root.geometry("500x500")

# Create the text area
text_area = tk.Text(root, height=10, width=30, font=("",20))
text_area.pack()
# Autofocus cursor in text area
text_area.focus()
# Create the button
button = tk.Button(root, text="Open App", font=("", 20))
button.pack()

# Create the label
label = tk.Label(root, text="", font=("", 15))
label.pack()
label.config(text="JUST ENTER NAME OF APPLICATION TO OPEN")

def open_app(event):
    # Get appl ication name
    app_name = text_area.get("1.0", "end")
    # Open application
    AppOpener.open(app_name)
    # Change the label accordingly
    label.config(text=str("Looking for "+app_name))
    text_area.delete("1.0", "end")

# Bind the button to the function
button.bind("<Button-1>", open_app)
root.mainloop()
