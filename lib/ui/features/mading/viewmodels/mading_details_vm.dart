import 'package:flutter/material.dart';
import 'package:raih/ui/features/mading/models/mading_detail_models.dart';

class MadingDetailViewModel extends ChangeNotifier {
  MadingDetailModel? _mading;
  bool _isLoading = true;

  MadingDetailModel? get mading => _mading;
  bool get isLoading => _isLoading;

  void fetchMadingDetail(String id) {
    _isLoading = true;
    notifyListeners();

    // Simulasi pengambilan data dummy berdasarkan ID postingan
    _mading = MadingDetailModel(
      id: id,
      categoryTag: "Lomba",
      title: "Hackathon Nasional Inovasi Digital 2026",
      organizer: "Kemendikbud RI",
      location: "Jakarta, DKI Jakarta",
      benefit: "Rp. 50.000.000",
      openDate: "15 Januari 2026",
      endDate: "31 Juli 2026",
      description:
          "Kompetisi hackathon tingkat nasional yang terbuka untuk mahasiswa aktif S1/D4 seluruh Indonesia. Peserta ditantang untuk menciptakan inovasi digital bernilai tinggi.",
      teamSize: "3–5 Orang",
      imageUrl:
          'assets/images/mading_details.png', // Dapat diisi URL/Asset foto nantinya
    );

    _isLoading = false;
    notifyListeners();
  }
}
