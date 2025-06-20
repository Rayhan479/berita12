import 'package:flutter/material.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff1E73BE)),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0x4D1E73BE),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.share, color: Color(0xff1E73BE)),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Color(0x4D1E73BE),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bookmark_border,
                color: Color(0xff1E73BE),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/berita.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'BlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBlaBIBlaBlaBlaBI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Technologia',
                      style: TextStyle(color: Color(0xff1E73BE)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.thumb_up,
                    size: 16,
                    color: Color(0xff1E73BE),
                  ),
                  const SizedBox(width: 4),
                  const Text('316K'),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.chat_bubble_outline,
                    size: 16,
                    color: Color(0xff1E73BE),
                  ),
                  const SizedBox(width: 4),
                  const Text('110K'),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.remove_red_eye,
                    size: 16,
                    color: Color(0xff1E73BE),
                  ),
                  const SizedBox(width: 4),
                  const Text('110K'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras nunc ex, molestie eu dapibus vel, facilisis nec nulla. Maecenas interdum lorem enim, sed consequat risus placerat a. Suspendisse sit amet risus eros. Nullam tincidunt elementum odio, ut sagittis orci eleifend a. Nulla rhoncus sapien ut pellentesque pellentesque. Ut gravida, tortor nec varius congue, libero lectus eleifend purus, quis auctor augue urna in mauris. Morbi nec augue nibh. Nulla varius, ante ut posuere commodo, lorem nisl vestibulum nibh, nec tincidunt mi metus ac nunc. In porta scelerisque volutpat. Fusce dapibus tincidunt lectus, a volutpat magna elementum sed. Fusce tortor eros, vulputate vel leo ut, cursus lobortis nunc. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.Duis nec erat metus. Cras tempus commodo lorem, nec dapibus lacus elementum id. Mauris vitae ligula id lectus ultricies condimentum. Nulla tellus urna, fermentum et iaculis et, tincidunt eget dui. Aenean massa mauris, cursus at ipsum ut, placerat viverra ex. Curabitur ut egestas dui. Vestibulum pulvinar ornare neque, et accumsan lacus accumsan eu. Sed vitae dignissim tortor. Donec nec quam arcu. Nam blandit lobortis nunc ac finibus. Phasellus rhoncus eget elit in tristique. Sed in ligula sed enim eleifend facilisis. Donec id nunc nec leo tincidunt aliquet. Suspendisse potenti. In hac habitasse platea dictumst. Quisque euismod, erat vel facilisis sodales, felis augue finibus est, a fringilla enim quam in nisi. Sed at dolor ac justo efficitur commodo. Integer non ligula sed odio semper convallis. Nulla facilisi. Donec nec quam arcu.',
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Text('Show All'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,

                children: const [
                  Chip(
                    label: Text(
                      '#Technologi',
                      style: TextStyle(color: Color(0xff1e73be)),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Chip(
                    label: Text(
                      '#AI',
                      style: TextStyle(color: Color(0xff1e73be)),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Chip(
                    label: Text(
                      '#Chat gpt',
                      style: TextStyle(color: Color(0xff1e73be)),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Technologi',
                      style: TextStyle(color: Color(0xff1e73be)),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  Chip(
                    label: Text(
                      'Technologi',
                      style: TextStyle(color: Color(0xff1e73be)),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff1E73BE)),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Comments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.png'),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment ...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color(0xff1E73BE),
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
