// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:etv_admin/mesfonctions/mesfonctions.dart';

// class PrixTicketsVip extends StatefulWidget {
//   const PrixTicketsVip({super.key});

//   @override
//   _PrixTicketsVipState createState() => _PrixTicketsVipState();
// }

// class _PrixTicketsVipState extends State<PrixTicketsVip> {
//   final _formKeyAjout = GlobalKey<FormState>();
//   final _formKeyModif = GlobalKey<FormState>();
//   final TextEditingController _prixController = TextEditingController();

//   List<Map<String, dynamic>> _prixList = [];
//   List<Map<String, dynamic>> _lignesSansPrix = [];
//   bool _isLoading = true;

//   static const _or = Color(0xFFFFD700);
//   static const _dark = Color(0xFF1A1A2E);

//   @override
//   void initState() {
//     super.initState();
//     _rafraichirDonnees();
//   }

//   @override
//   void dispose() {
//     _prixController.dispose();
//     super.dispose();
//   }

//   Future<void> _rafraichirDonnees() async {
//     if (mounted) setState(() => _isLoading = true);
//     try {
//       final results = await Future.wait([
//         http.get(apiUri('api_lignes.php?type=vip')),
//         http.get(apiUri('api_lignes.php?type=vip&sans_prix=1')),
//       ]);

//       if (mounted) {
//         final prixData = jsonDecode(results[0].body);
//         final sansPrixData = jsonDecode(results[1].body);

//         setState(() {
//           if (prixData['success'] == true) {
//             _prixList = List<Map<String, dynamic>>.from(
//               prixData['lignes'],
//             ).where((l) => (l['prix'] as int) > 0).toList();
//           }
//           if (sansPrixData['success'] == true) {
//             _lignesSansPrix = List<Map<String, dynamic>>.from(
//               sansPrixData['lignes'],
//             );
//           }
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _ajouter(int idLigne, int prix) async {
//     try {
//       final ligne = _lignesSansPrix.firstWhere((l) => l['id'] == idLigne);
//       await http.post(
//         apiUri('api_lignes.php'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'action': 'modifier',
//           'id': idLigne,
//           'depart': ligne['depart'],
//           'destination': ligne['destination'],
//           'ligne': ligne['ligne'],
//           'prix': prix,
//         }),
//       );
//       await _rafraichirDonnees();
//     } catch (e) {}
//   }

//   Future<void> _modifier(
//     int id,
//     String depart,
//     String destination,
//     String ligne,
//     int prix,
//   ) async {
//     try {
//       await http.post(
//         apiUri('api_lignes.php'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'action': 'modifier',
//           'id': id,
//           'depart': depart,
//           'destination': destination,
//           'ligne': ligne,
//           'prix': prix,
//         }),
//       );
//       await _rafraichirDonnees();
//     } catch (e) {}
//   }

//   void _afficherMessage(String message, {bool isError = true}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.red : _or,
//         duration: const Duration(seconds: 3),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _dark,
//       appBar: AppBar(
//         backgroundColor: _dark,
//         iconTheme: const IconThemeData(color: _or),
//         centerTitle: true,
//         title: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.star, color: _or, size: 20),
//             SizedBox(width: 8),
//             Text(
//               'Prix VIP',
//               style: TextStyle(color: _or, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: _or),
//             onPressed: _rafraichirDonnees,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator(color: _or))
//           : _prixList.isEmpty
//           ? const Center(
//               child: Text(
//                 'Aucun prix VIP enregistré',
//                 style: TextStyle(color: _or, fontWeight: FontWeight.bold),
//               ),
//             )
//           : ListView.builder(
//               itemCount: _prixList.length,
//               itemBuilder: (context, index) {
//                 final ticket = _prixList[index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF16213E),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: _or, width: 1.2),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.amber.withOpacity(0.15),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: _or,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(Icons.star, color: _dark, size: 24),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 ticket['ligne'].toString(),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15,
//                                   color: _or,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '${ticket['prix']} FCFA',
//                                 style: const TextStyle(
//                                   fontSize: 13,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: _or),
//                           onPressed: () =>
//                               _afficherModalModifier(context, ticket),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: _lignesSansPrix.isEmpty
//           ? null
//           : FloatingActionButton(
//               backgroundColor: _or,
//               onPressed: () => _afficherModalAjouter(context),
//               child: const Icon(Icons.add, color: _dark),
//             ),
//     );
//   }

//   void _afficherModalAjouter(BuildContext context) {
//     int? ligneSelectionnee;
//     _prixController.clear();

//     showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF16213E),
//       context: context,
//       builder: (ctx) => StatefulBuilder(
//         builder: (ctx2, setModalState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               top: 20,
//               left: 20,
//               right: 20,
//               bottom: MediaQuery.of(ctx2).viewInsets.bottom + 20,
//             ),
//             child: Form(
//               key: _formKeyAjout,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.star, color: _or, size: 16),
//                       SizedBox(width: 6),
//                       Text(
//                         'Ajouter un prix VIP',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: _or,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),

//                   // Dropdown lignes sans prix
//                   DropdownButtonFormField<int>(
//                     value: ligneSelectionnee,
//                     dropdownColor: const Color(0xFF16213E),
//                     style: const TextStyle(color: _or),
//                     decoration: const InputDecoration(
//                       labelText: 'Ligne',
//                       labelStyle: TextStyle(color: _or),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: _or),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: _or, width: 2),
//                       ),
//                     ),
//                     items: _lignesSansPrix
//                         .map(
//                           (l) => DropdownMenuItem<int>(
//                             value: l['id'] as int,
//                             child: Text(
//                               l['ligne'].toString(),
//                               style: const TextStyle(color: _or),
//                             ),
//                           ),
//                         )
//                         .toList(),
//                     onChanged: (val) =>
//                         setModalState(() => ligneSelectionnee = val),
//                     validator: (v) => v == null ? 'Choisissez une ligne' : null,
//                   ),

//                   const SizedBox(height: 8),

//                   TextFormField(
//                     controller: _prixController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: const InputDecoration(
//                       labelText: 'Prix (FCFA)',
//                       labelStyle: TextStyle(color: _or),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: _or),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: _or, width: 2),
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (v) {
//                       if (v == null || v.isEmpty) {
//                         return 'Veuillez entrer un prix';
//                       }
//                       if (int.tryParse(v) == null || int.parse(v) <= 0) {
//                         return 'Entrer un nombre valide supérieur à 0';
//                       }
//                       return null;
//                     },
//                   ),

//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _or,
//                       minimumSize: const Size(double.infinity, 45),
//                     ),
//                     onPressed: () async {
//                       if (_formKeyAjout.currentState!.validate()) {
//                         Navigator.of(context).pop();
//                         await _ajouter(
//                           ligneSelectionnee!,
//                           int.parse(_prixController.text.trim()),
//                         );
//                         _afficherMessage(
//                           'Prix VIP ajouté avec succès',
//                           isError: false,
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'Ajouter',
//                       style: TextStyle(
//                         color: _dark,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _afficherModalModifier(
//     BuildContext context,
//     Map<String, dynamic> ticket,
//   ) {
//     _prixController.text = ticket['prix'].toString();

//     showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: const Color(0xFF16213E),
//       context: context,
//       builder: (ctx) => Padding(
//         padding: EdgeInsets.only(
//           top: 20,
//           left: 20,
//           right: 20,
//           bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
//         ),
//         child: Form(
//           key: _formKeyModif,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.star, color: _or, size: 16),
//                   SizedBox(width: 6),
//                   Text(
//                     'Modifier le prix VIP',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: _or,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // Ligne en lecture seule
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 14,
//                   horizontal: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF0F3460),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: _or),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.star, color: _or, size: 16),
//                     const SizedBox(width: 8),
//                     Text(
//                       ticket['ligne'].toString(),
//                       style: const TextStyle(
//                         color: _or,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 8),

//               TextFormField(
//                 controller: _prixController,
//                 style: const TextStyle(color: Colors.white),
//                 decoration: const InputDecoration(
//                   labelText: 'Prix (FCFA)',
//                   labelStyle: TextStyle(color: _or),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: _or),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: _or, width: 2),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (v) {
//                   if (v == null || v.isEmpty) {
//                     return 'Veuillez entrer un prix';
//                   }
//                   if (int.tryParse(v) == null || int.parse(v) <= 0) {
//                     return 'Entrer un nombre valide supérieur à 0';
//                   }
//                   return null;
//                 },
//               ),

//               const SizedBox(height: 16),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: _or,
//                   minimumSize: const Size(double.infinity, 45),
//                 ),
//                 onPressed: () async {
//                   if (_formKeyModif.currentState!.validate()) {
//                     Navigator.of(ctx).pop();
//                     await _modifier(
//                       ticket['id'],
//                       ticket['depart'].toString(),
//                       ticket['destination'].toString(),
//                       ticket['ligne'].toString(),
//                       int.parse(_prixController.text.trim()),
//                     );
//                     _afficherMessage(
//                       'Prix VIP modifié avec succès',
//                       isError: false,
//                     );
//                   }
//                 },
//                 child: const Text(
//                   'Modifier',
//                   style: TextStyle(color: _dark, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
