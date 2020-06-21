# Third-Eye
An iOS app for empowering visually impaired to help to find their belongings and overcome day-to-day struggles through the Mobile camera as "Third Eye" using Object Detection Algorithm and Speech Recognition.

Check out the demo of our app [@Youtube](https://www.youtube.com/watch?v=b543EcMP2SA&feature=emb_logo)

![Image of Phone](https://hackumass.blob.core.windows.net/hackumass-vii/project/Third%20Eye.png?1571581038)

# Inspiration:
One morning my grandma woke up and could not find her glasses and medications although they were just on the other side of the bedroom; I once met a visually impaired couple in Perkins Hackathon who shared their story of day-to-day struggles in their life finding items in their house when they forget to keep each items in the right place/ location. We made this app in the hopes to accommodate people like my own grandma and the millions of visually impaired people around the globe.

# What it Does:

The app takes input from User to find a specific item using speech-to-text and detects the requested object in the room in "REAL-TIME" and using beep sensing and vibration in the mobile phone it will guide the user to the item.

# What is behind the screen:
Using Object Detection algorithm via Pre-trained RESNET50, we designed an object detection and classification deep neural network and  deployed it diretly on iphone. Used inbuilt iOS Speech-to-Text Feature and incorporating multi-threading to perform multiple activities at the same time

# Technologies we used:

Swift| Objective C | Xcode 11.2 | Swift 5.1 | Python | AVFoundation | Vision | Speech | UIKit

# Challenges we ran into:
- Detecting object in "real-time"

- In order to decrease the latency of response from the deep learning model, we had to integrate the neural network with the iOS platform and deploy the model on the mobile phone itself, instead of relying on a cloud service and getting detection results from the cloud

- Choosing the most-fit Object Detection Algorithm

- Integrating the neural network on an iOS platform instead of on a cloud service

# What's next:
Extending our app using Drone which can help to find items without any human support and can freely rotate in 360 angles. It would be interesting to use a combination of MobileNet and SSD to detect an object in real-time video streaming.

We developed this prototype application in nearly 36 hrs at Umass Hack.

Collaborators Hitesh Verma | Parag Bhingarkar | Prashuk Ajmera
