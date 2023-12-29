import {Text} from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import {useState} from "react";

export default function SettingsGeneralCard() {

    const languageList = [
        {
            label: "English",
            value: "EN",
        },
        {
            label: "Ukrainian",
            value: "UA",
        },
    ];

    const [language, setLanguage] = useState("EN");

    return (
        <InputCard title={"General"}>
            <Grid style={styleSheet.grid.grid}>

                <Row style={styleSheet.grid.row}>
                    <Col size={6}>
                        <Text>{"Language"}</Text>
                    </Col>
                    <Col size={4}>
                        <SimpleModal title={"Language"} text={language} icon={"translate"}>
                            <LanguagePicker language={language}
                                            setLanguage={setLanguage} languageList={languageList} />
                        </SimpleModal>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )

}