# edit these to what you want
# number of LEDs in your chain (only supports one channel up to 64 for now)
num_leds = 40
# number of frames to animate
num_frames = 2
# delay in seconds between each frame
delay = 0.5
# fcserver hostname
hostname = "localhost"
# how much to darken the colours
darken = 0.3

#initialize the frames
frames = [None]*num_frames
for i in range(0,num_frames):
    frames[i] = "\\x00\\x00\\x00\\x%x" % (num_leds*3)
    frames[i] = "\\x00\\x00\\x00\\x%x" % (num_leds*3)

for i in range(0,num_leds):
    # red
    if i % 2 == 0:
        # r for frames[0]
        frames[0] = frames[0]+("\\x%02x\\x00\\x00" % (darken * 255))
        # g for frames[1]
        frames[1] = frames[1]+("\\x00\\x%02x\\x00" % (darken * 255))
    else:
        # g for frames[0]
        frames[0] = frames[0]+("\\x00\\x%02x\\x00" % (darken * 255))
        # r for frames[1]
        frames[1] = frames[1]+("\\x%02x\\x00\\x00" % (darken * 255))

outbash = "while true; do\n"
for i in range(0,num_frames):
    outbash = outbash+"echo -ne '%s' | nc %s 7890\n" % (frames[i], hostname)
    outbash = outbash+"sleep %f\n" % (delay)
outbash = outbash+"done"

f = file('animation.sh', 'w')
f.write(outbash)
f.close()
print("created animation.sh\n")
