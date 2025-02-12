const router = require("express").Router();
const UserController = require("../controller/user_controller.js");

router.post("/registro", UserController.register);
router.post("/log", UserController.login);
router.put("/updateNAG", UserController.updateUserDataByAgeNameGender);
router.put("/updateLO", UserController.updateUserDataByLocalOcupation);
router.put("/updateSalud", UserController.updateUserDataBySaludHistorico);
router.get("/getName/:email", UserController.getUserNameByEmail);
router.put("/updatePC", UserController.updateUserDataByPressureColesterol);
router.get("/getProfileComplete/:email", UserController.getProfileComplete);
router.put("/updatePA", UserController.updateBMI);
router.put("/updateExeLevel", UserController.updateUserDataByExcerciseLevel);
router.put("/updateDietWater", UserController.updateUserDataByDietAndWater);
router.put("/updateStress", UserController.updateUserDataByEstresLevel);
router.put("/updateHeart", UserController.updateUserDataByHeart);
router.put("/updateBeer", UserController.updateUserDataByBeer);
router.put("/updateBeer", UserController.updateUserDataByBeer);
router.put("/updateST", UserController.updateUserDataST);
router.put("/updateU", UserController.updateUserDataByFrecuencia);
router.put("/updateSmoke", UserController.updateUserSmoke);
//Para el calculo final
router.get(
  "/getUnidadesAlcohol/:email",
  UserController.getUnidadesAlcoholByEmail
);
router.get("/getConsumo/:email", UserController.getConsumoPorDiasByEmail);
router.get("/getFrecuencia/:email", UserController.getFrecuenciaSemanalByEmail);
router.put("/calcularConsumo", UserContoller.updateSTU);

module.exports = router;
