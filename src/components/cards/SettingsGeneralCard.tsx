import {Text} from "react-native-paper"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "./InputCard";
import styleSheet from "../../styles";

import {useState} from "react";
import RadioGroup from "../radio-group/RadioGroup";
import {SimpleScrollDialog} from "../dialogs";
import {useTranslate} from "../../translations/UseTranslate";
import {useUserData, UserDataProvider} from "../../user-data/UserDataContext";

export default function SettingsGeneralCard() {

    // translator
    const me = SettingsGeneralCard.name
    const translator = useTranslate()
    const tr = (str) => translator(me, str)


    const {userData, saveUserData} = useUserData();
    if (userData?.language) {

    }

    const curLanguage = () => {
        return userData?.language ? userData.language : "EN"
    }
    const setCurLanguage = (language) => {
        const updatedData = {...userData, language: language}; // Modify as needed
        saveUserData(updatedData);
    }

    const languageList = [
        {
            label: "English",
            value: "EN",
            key: "EN"
        },
        {
            label: "Українська",
            value: "UA",
            key: "UA"
        },
    ];

    const [language, setLanguage] = useState(curLanguage());

    const onAccept = () => {
        setCurLanguage(language)
    }

    const onDecline = () => {
        setLanguage(curLanguage())
    }

    return (

        <InputCard title={tr("General")}>
            <Grid style={styleSheet.grid.grid}>

                <Row style={styleSheet.grid.row}>
                    <Col size={9}>
                        <Text style={{fontSize: 16}}>{tr("Language")}</Text>
                    </Col>
                    <Col size={7}>
                        <SimpleScrollDialog title={tr("Language")} text={curLanguage()} icon={"translate"}
                                            onAccept={onAccept}
                                            onDecline={onDecline}>
                            <RadioGroup initialValue={curLanguage()} onChange={setLanguage} items={languageList}/>
                        </SimpleScrollDialog>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )

}
