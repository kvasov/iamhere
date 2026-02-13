import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/photos.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/description.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/reviews.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:iamhere/features/place/presentation/widgets/place_screen/place_head.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/map_view.dart';
import 'package:iamhere/features/place/presentation/etc/sections_enum.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlacesBloc>(
      create: (_) => di.sl<PlacesBloc>(),
      child: PlaceView(),
    );
  }
}

class PlaceView extends StatefulWidget {
  const PlaceView({super.key});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  String? _loadedPlaceId;
  bool _isMapInteracting = false;

  final ScrollController _scrollController = ScrollController();
  PlaceSection _activeSection = PlaceSection.map;

  final _mapKey = GlobalKey();
  final _descriptionKey = GlobalKey();
  final _photosKey = GlobalKey();
  final _reviewsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final sections = {
      PlaceSection.map: _mapKey,
      PlaceSection.description: _descriptionKey,
      PlaceSection.photos: _photosKey,
      PlaceSection.reviews: _reviewsKey,
    };

    PlaceSection? newActive;

    for (final entry in sections.entries) {
      final context = entry.value.currentContext;
      if (context == null) continue;

      final box = context.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero).dy - MediaQuery.of(context).padding.top;

      // 👇 значение подбирается под AppBar
      if (offset <= MediaQuery.of(context).size.height * 0.3) {
        newActive = entry.key;
      }
    }

    if (newActive != null && newActive != _activeSection) {
      debugPrint('newActive: $newActive');
      setState(() {
        _activeSection = newActive!;
      });
    }
  }

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeId = GoRouterState.of(context).pathParameters['placeId'];

    // Отправляем событие загрузки только один раз при первом рендере
    if (placeId != null && _loadedPlaceId != placeId) {
      _loadedPlaceId = placeId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<PlacesBloc>().add(PlaceLoadEvent(placeId: placeId));
        }
      });
    }

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        if (state is PlaceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PlaceError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is PlaceLoaded) {
          return Scaffold(
            // backgroundColor: Colors.blueGrey,
            body: CustomScrollView(
              controller: _scrollController,
              physics: _isMapInteracting
                  ? const NeverScrollableScrollPhysics()
                  : null,
              slivers: [
                PlaceHead(
                  place: state.place,
                  onMapTap: () => _scrollTo(_mapKey),
                  onDescriptionTap: () => _scrollTo(_descriptionKey),
                  onPhotosTap: () => _scrollTo(_photosKey),
                  onReviewsTap: () => _scrollTo(_reviewsKey),
                  activeSection: _activeSection,
                ),
                SliverToBoxAdapter(
                  child: Listener(
                    key: _mapKey,
                    onPointerDown: (_) => setState(() => _isMapInteracting = true),
                    onPointerUp: (_) => setState(() => _isMapInteracting = false),
                    onPointerCancel: (_) => setState(() => _isMapInteracting = false),
                    child: MapView(place: state.place),
                  ),
                ),

                // SliverToBoxAdapter(
                //   child: Container(
                //     color: Colors.white,
                //     child: Column(
                //       children: [
                //         Text('Nmae: ${state.place.name}'),
                //         Text('Latitude: ${state.place.latitude}'),
                //         Text('Longitude: ${state.place.longitude}'),
                //         Text('Country: ${state.place.country}'),
                //         Text('Address: ${state.place.address}'),
                //         Text('Image URL: ${state.place.imageUrl}'),
                //       ],
                //     ),
                //   ),
                // ),

                PlaceDescription(
                  description: state.place.description ?? '',
                  descriptionKey: _descriptionKey,
                ),

                PlacePhotos(photos: state.place.photos ?? [], photosKey: _photosKey),

                PlaceReviews(reviews: state.place.reviews ?? [], reviewsKey: _reviewsKey),
                SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
                // SliverFillRemaining(
                //   hasScrollBody: true,
                //   child: Container(
                //     color: Colors.white,
                //     child: Column(
                //       children: [
                //         Text('Nmae: ${state.place.name}'),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}