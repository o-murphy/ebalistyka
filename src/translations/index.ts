// import UA from "./ukrainian";
// // import {useUserData} from "../user-data/UserDataContext";
// import {useUserData} from "../user-data/UserDataContext";
//
//
//
// const languages = {
//     UA: UA,
// }
//
//
// const Translate = (context: string, str: string) => {
//
//     const {userData, saveUserData} = useUserData();
//     const lang = () => {
//         return userData?.language ? userData.language : "EN"
//     }
//     console.log("translator", lang())
//
//     return languages?.[lang()]?.[context]?.[str] ? languages[lang()][context][str] : str
// }
//
// export {Translate as Tr};