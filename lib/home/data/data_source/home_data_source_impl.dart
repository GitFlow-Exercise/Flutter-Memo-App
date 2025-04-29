import 'home_data_source.dart';
import '../dto/home_dto.dart';

class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<HomeDto> getHomeInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const HomeDto(
      title: 'Flutter 웹 앱에 오신 것을 환영합니다',
      description:
          '최신 웹 기술을 활용한 Flutter 애플리케이션입니다. MVI, Clean Architecture, MVVM 패턴을 적용하였습니다.',
      imageUrl:
          'https://storage.googleapis.com/cms-storage-bucket/70760bf1e88b184bb1bc.png',
    );
  }
}
