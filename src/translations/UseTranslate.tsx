// useTranslate.js
import { useUserData } from "../user-data/UserDataContext";
import UA from "./ukrainian";

const languages = {
    UA: UA,
    // Add other languages here
};

export const useTranslate = () => {
    const { userData } = useUserData();

    const translate = (context, str) => {
        const lang = userData?.language ? userData.language : "EN";
        console.log("translator", lang);
        return languages[lang]?.[context]?.[str] ? languages[lang][context][str] : str;
    };

    return translate;
};