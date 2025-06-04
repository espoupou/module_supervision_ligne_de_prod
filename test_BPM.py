import tkinter as tk
import time
import winsound

class MetronomeApp:
    def __init__(self, root, takt_time, num_postes):
        self.root = root
        self.takt_time = takt_time
        self.num_postes = num_postes
        self.start_time = None
        self.compteur = 0
        self.running = False

        # Top-right label for the current post
        self.post_label = tk.Label(root, text="Poste: 1", font=("Arial", 14, "bold"), fg="#007ACC")
        self.post_label.place(x=400, y=10)  # Positioned in the top-right corner

        # Centered Timer
        self.label = tk.Label(root, text="00", font=("Arial", 90, "bold"), fg="#333")
        self.label.pack(pady=20)

        # Frame for buttons (side by side)
        self.button_frame = tk.Frame(root)
        self.button_frame.pack()

        # Start and Stop buttons
        self.start_button = tk.Button(self.button_frame, text="Start", font=("Arial", 14), bg="#4CAF50", fg="white", width=10, command=self.start_metronome)
        self.start_button.grid(row=0, column=0, padx=10, pady=10)

        self.stop_button = tk.Button(self.button_frame, text="Stop", font=("Arial", 14), bg="#F44336", fg="white", width=10, command=self.stop_metronome)
        self.stop_button.grid(row=0, column=1, padx=10, pady=10)

    def start_metronome(self):
        if not self.running:
            self.running = True
            self.start_time = time.time()
            self.update_timer()

    def stop_metronome(self):
        self.running = False

    def update_timer(self):
        if self.running:
            elapsed = int(time.time() - self.start_time)
            self.label.config(text=f"{elapsed:02d}")

            if elapsed >= self.takt_time:
                self.compteur += 1
                poste = (self.compteur % self.num_postes) + 1
                self.label.config(text="00")  # Reset timer display
                self.post_label.config(text=f"Poste: {poste}")  # Update post number
                winsound.Beep(1000, 500)
                self.start_time = time.time()  # Reset timer

            self.root.after(100, self.update_timer)  # Update every 100ms

# Configuration
takt_time = 10  # Takt Time in seconds
num_postes = 5  # Number of stations

# Run the GUI
root = tk.Tk()
root.title("Metronome")
root.geometry("500x300")  # Adjust window size
root.resizable(False, False)  # Disable resizing

app = MetronomeApp(root, takt_time, num_postes)
root.mainloop()
