import 'package:flutter/material.dart';
import 'package:flutter_ornek/album.dart';
import 'package:video_player/video_player.dart';

import 'input_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    print('myapp yaratılıyor');
  }

  @override
  Widget build(BuildContext context) {
    print('myapp build');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {
    print('myhomepage yaratılıyor');
  }

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState() {
    print('myhomepagestate yaratılıyor');
  }

  @override
  void initState() {
    super.initState();
    ogrenciler.add('init');
  }

  var sinif = 5;
  var baslik = 'Öğrenciler';
  var ogrenciler = ['Ali', 'Ayşe', 'Can'];

  void yeniOgrenciEkle(String yeniOgrenci) {
    setState(() {
      ogrenciler = [...ogrenciler, yeniOgrenci];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('myhomepagestate build');

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              print('settings!');
              Navigator.of(context).pushNamed('/settings');
            },
            icon: Icon(Icons.settings),
          ),
          TextButton(
            child: Container(
              child: Text(
                'merhaba',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {
              print('merhaba');
            },
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        child: SinifBilgisi(
          sinif: sinif,
          baslik: baslik,
          ogrenciler: ogrenciler,
          yeniOgrenciEkle: yeniOgrenciEkle,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ArkaPlan(),
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                bottom: 120,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    print('constraints.maxWidth: ${constraints.maxWidth}');
                    if (constraints.maxWidth > 550) {
                      return Row(
                        children: [
                          Sinif(),
                          Expanded(child: Text('Seçili olan öğrencinin detayları')),
                        ],
                      );
                    } else {
                      return Sinif();
                    }
                  }
                ),
              ),
              Positioned(
                bottom: 20,
                left: 10,
                right: 10,
                child: OgrenciEkleme(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('merhaba');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('MERHABA!')),
          );
        },
        child: Text('FAB'),
      ),
    );
  }
}

class SinifBilgisi extends InheritedWidget {
  const SinifBilgisi({
    Key? key,
    required Widget child,
    required this.sinif,
    required this.baslik,
    required this.ogrenciler,
    required this.yeniOgrenciEkle,
  }) : super(key: key, child: child);

  final int sinif;
  final String baslik;
  final List<String> ogrenciler;
  final void Function(String yeniOgrenci) yeniOgrenciEkle;

  static SinifBilgisi of(BuildContext context) {
    final SinifBilgisi? result =
        context.dependOnInheritedWidgetOfExactType<SinifBilgisi>();
    assert(result != null, 'No SinifBilgisi found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(SinifBilgisi old) {
    return sinif != old.sinif ||
      baslik != old.baslik ||
      ogrenciler != old.ogrenciler ||
      yeniOgrenciEkle != old.yeniOgrenciEkle;
  }
}

class Sinif extends StatelessWidget {
  const Sinif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Colors.red,
            ),
            Text(
              '${sinifBilgisi.sinif}. Sınıf',
              textScaleFactor: 2,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            Icon(
              Icons.star,
            ),
          ],
        ),
        Container(
          color: Colors.red,
          padding: const EdgeInsets.only(top: 30) + const EdgeInsets.all(4),
          child: Text(
            sinifBilgisi.baslik,
            textScaleFactor: 1.5,
          ),
        ),
        Expanded(child: OgrenciListesi()),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: RichText(
            text: TextSpan(
              text: 'Öğencileri ',
              children: const <TextSpan>[
                TextSpan(
                  text: 'Yükle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
          onPressed: () async {
            final ogrenciler = SinifBilgisi.of(context).ogrenciler;

            for (final ogrenci in ogrenciler) {
              print('$ogrenci yukleniyor');
              await Future.delayed(Duration(seconds: 1));
              print('$ogrenci yuklendi');
            }

            print('Tüm öğrenciler yüklendi');
          },
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text(
            'Yeni sayfaya git',
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AlbumPage(),
            ));
            // sor(context);
          },
        ),
        ElevatedButton(
          child: Text(
            'Girdi sayfasına git',
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InputPage(),
            ));
            // sor(context);
          },
        ),
      ],
    );
  }

  Future<void> sor(BuildContext context) async {
    try {
      bool? cevap = await cevabiAl(context);

      print('cevap geldi: $cevap');
      if (cevap == true) {
        print('beğendi!!!');
        throw 'HATA OLSUN...';
      } else {
        cevap =
            await Navigator.of(context).push<bool>(MaterialPageRoute(
          builder: (context) {
            return VideoEkrani(
                'Keşke beğenseniz... Videoyu beğendiniz mi?');
          },
        ));
      }
      if (cevap == true) {
        print('BEĞENDINIZ!!!');
      }
    } catch (e) {
      print('HATA!');
    } finally {
      print('---- iş bitti! -----');
    }
  }

  Future<bool?> cevabiAl(BuildContext context) async {
    bool? cevap =
        await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) {
        return VideoEkrani('Videoyu beğendiniz mi?');
      },
    ));
    return cevap;
  }
}

class VideoEkrani extends StatelessWidget {
  final String mesaj;
  const VideoEkrani(this.mesaj, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('pop edecek');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              // Video(),
              Placeholder(
                fallbackHeight: 150,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                mesaj
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(true);
                },
                child: Text(
                  'Evet',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).maybePop(false);
                },
                child: Text(
                  'Hayır',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ekran3 extends StatefulWidget {
  const Ekran3({Key? key}) : super(key: key);

  @override
  _Ekran3State createState() => _Ekran3State();
}

class _Ekran3State extends State<Ekran3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('Ekran 3'),
      ),
    );
  }
}


class Video extends StatefulWidget {
  const Video({Key? key}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        ElevatedButton(
          child: Text(
            'Play/Pause',
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        ),
      ],
    );
  }
}


class OgrenciListesi extends StatelessWidget {
  const OgrenciListesi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          key: ValueKey(index),
          leading: Icon(Icons.circle),
          title: Text(
            sinifBilgisi.ogrenciler[index],
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        );
      },
      itemCount: sinifBilgisi.ogrenciler.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.black,
        );
      },

    );
  }
}

class OgrenciEkleme extends StatefulWidget {

  const OgrenciEkleme({
    Key? key,
  }) : super(key: key);

  @override
  State<OgrenciEkleme> createState() => _OgrenciEklemeState();
}

class _OgrenciEklemeState extends State<OgrenciEkleme> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sinifBilgisi = SinifBilgisi.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {
            });
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: controller.text.isEmpty ? null : () {
              final yeniOgrenci = controller.text;
              sinifBilgisi.yeniOgrenciEkle(yeniOgrenci);
              controller.text = '';
              print(MediaQuery.of(context).size);
            },
            child: Text(
              'Ekle',
            ),
          ),
        ),
      ],
    );
  }
}

class ArkaPlan extends StatelessWidget {
  const ArkaPlan({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: PhysicalModel(
        color: Colors.white,
        shadowColor: Colors.green,
        elevation: 30,
        borderRadius: BorderRadius.all(Radius.circular(50)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 10,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 58.0, vertical: 16.0),
                  child: Image(image: AssetImage('images/homepage_img_8.png'),),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Container(
        child: Text('Settings Page'),
      ),
    );
  }
}
