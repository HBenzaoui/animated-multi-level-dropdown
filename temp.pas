if FSplashVersement.Tag = 7 then
  begin
     if VerVersementSEdt.Text<>'' then
     begin
     BonComAGestionF.BonComRegleLbl.Caption:=  FloatToStrF(StrToFloat(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll])),ffNumber,14,2);
     BonComAGestionF.BonComResteLbl.Caption:=  FloatToStrF((
             (StrToFloat (StringReplace(MontantTTCVersementSLbl.Caption, #32, '', [rfReplaceAll])))
             -
             (StrToFloat (StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll])))
             ),ffNumber,14,2);

     BonComAGestionF.BonComGFourNEWCredit.Caption := ResteVersementSLbl.Caption;

     AnimateWindow(FSplashVersement.Handle, 175, AW_VER_NEGATIVE OR AW_SLIDE OR AW_HIDE);
     FSplashVersement.Release;
     sndPlaySound('C:\Windows\Media\speech on.wav', SND_NODEFAULT Or SND_ASYNC Or SND_RING);
     DisableBonCom;

//--- this is for adding to the priduit
//--- we dont need to add in stock becuxz it just a bon commande 
      // begin
      // end;

//--- this is to set the bon command fileds
     begin
//          MainForm.SQLQuery.DisableControls;
          MainForm.SQLQuery.Active:=false;
          MainForm.SQLQuery.SQL.Clear;
          MainForm.SQLQuery.SQL.Text:='Select * FROM fournisseur WHERE LOWER(nom_f) LIKE LOWER('+ QuotedStr(BonComAGestionF.FournisseurBonComGCbx.Text )+')'  ;
          MainForm.SQLQuery.Active:=True;

          MainForm.Mode_paiementTable.DisableControls;
          MainForm.Mode_paiementTable.Active:=false;
          MainForm.Mode_paiementTable.SQL.Clear;
          MainForm.Mode_paiementTable.SQL.Text:='Select * FROM mode_paiement WHERE LOWER(nom_mdpai) LIKE LOWER('+ QuotedStr(BonComAGestionF.ModePaieBonComGCbx.Text )+')'  ;
          MainForm.Mode_paiementTable.Active:=True;

          MainForm.CompteTable.DisableControls;
          MainForm.CompteTable.Active:=false;
          MainForm.CompteTable.SQL.Clear;
          MainForm.CompteTable.SQL.Text:='Select * FROM compte WHERE LOWER(nom_cmpt) LIKE LOWER('+ QuotedStr(BonComAGestionF.CompteBonComGCbx.Text )+')'  ;
          MainForm.CompteTable.Active:=True;

     //     DataModuleF.Bona_comTable.DisableControls;
          DataModuleF.Bona_comTable.Edit;
          DataModuleF.Bona_comTable.FieldValues['code_f']:= MainForm.SQLQuery.FieldByName('code_f').AsInteger;
          DataModuleF.Bona_comTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);
          DataModuleF.Bona_comTable.FieldValues['date_bacom']:= BonComAGestionF.DateBonComGD.DateTime;
          DataModuleF.Bona_comTable.FieldValues['time_bacom']:=TimeOf(Now);
          DataModuleF.Bona_comTable.FieldValues['code_mdpai']:= MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
          DataModuleF.Bona_comTable.FieldValues['code_cmpt']:= MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
          DataModuleF.Bona_comTable.FieldValues['obser_bacom']:= BonComAGestionF.ObserBonComGMem.Text;
          DataModuleF.Bona_comTable.FieldValues['num_cheque_bacom']:= BonComAGestionF.NChequeBonComGCbx.Text;
          DataModuleF.Bona_comTable.FieldByName('montht_bacom').AsCurrency:= StrToCurr(StringReplace(BonComAGestionF.BonComTotalHTLbl.Caption, #32, '', [rfReplaceAll]));
          if BonComAGestionF.RemiseBonComGEdt.Text<>'' then
          begin
          DataModuleF.Bona_comTable.FieldByName('remise_bacom').AsCurrency:=StrToCurr(StringReplace(BonComAGestionF.RemiseBonComGEdt.Text, #32, '', [rfReplaceAll]));
          end else begin
                    DataModuleF.Bona_comTable.FieldByName('remise_bacom').AsCurrency:=0;
                   end;

          DataModuleF.Bona_comTable.FieldByName('montver_bacom').AsCurrency:=StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));
          DataModuleF.Bona_comTable.FieldByName('montttc_bacom').AsCurrency:=StrToCurr(StringReplace(BonComAGestionF.BonComTotalTTCLbl.Caption, #32, '', [rfReplaceAll]));
          DataModuleF.Bona_comTable.FieldByName('valider_bacom').AsBoolean:= True;
          DataModuleF.Bona_comTable.FieldByName('bon_or_no_bacom').AsBoolean:= True;

          if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='espece') then
          begin
           DataModuleF.Bona_comTable.FieldValues['code_mdpai']:=1 ;
          end;
           if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='cheque') then
          begin
           DataModuleF.Bona_comTable.FieldValues['code_mdpai']:=2 ;
          end;
          if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='a terme' )
             OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) then
          begin
           DataModuleF.Bona_comTable.FieldValues['code_mdpai']:=3 ;
          end;
          if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
          begin
           DataModuleF.Bona_comTable.FieldValues['code_mdpai']:=4 ;
          end;

          DataModuleF.Bona_comTable.Post;
     //     DataModuleF.Bona_comTable.EnableControls;

    //-----------------------------------------------------------------------------------------------------------------------------------
        if (VerVersementSEdt.Text <> '' ) AND (VerVersementSEdt.Text <> '0' ) AND ((StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll])))<> 0 ) then
        begin
          if BonComAGestionF.Tag = 0 then
          begin
             if NOT (MainForm.RegfournisseurTable.IsEmpty) then
            begin
            MainForm.RegfournisseurTable.Last;
            CodeRF:= MainForm.RegfournisseurTable.FieldValues['code_rf'] + 1;
            end else
                begin
                 CodeRF:= 1;
                end;

            MainForm.RegfournisseurTable.Append;
            MainForm.RegfournisseurTable.FieldValues['code_rf']:= CodeRF;
            MainForm.RegfournisseurTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
            MainForm.RegfournisseurTable.FieldValues['nom_rf']:= BonComAGestionF.NumBonComGEdt.Caption;
            MainForm.RegfournisseurTable.FieldValues['code_f']:= MainForm.SQLQuery.FieldByName('code_f').AsInteger;
            MainForm.RegfournisseurTable.FieldValues['date_rf']:= DateOf(Today);
            MainForm.RegfournisseurTable.FieldValues['time_rf']:=TimeOf(Now);
            MainForm.RegfournisseurTable.FieldValues['code_mdpai']:= MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
            MainForm.RegfournisseurTable.FieldValues['code_cmpt']:= MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
            MainForm.RegfournisseurTable.FieldValues['obser_rf']:= BonComAGestionF.ObserBonComGMem.Text;
            MainForm.RegfournisseurTable.FieldValues['num_cheque_rf']:= BonComAGestionF.NChequeBonComGCbx.Text;
            MainForm.RegfournisseurTable.FieldValues['bon_or_no_rf']:= 2;
            MainForm.RegfournisseurTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);

            MainForm.RegfournisseurTable.FieldByName('montver_rf').AsCurrency:=StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='espece') then
            begin
             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=1 ;
            end;
             if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='cheque') then
            begin
             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=2 ;
            end;
            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='a terme' )
               OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) then
            begin
             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=3 ;
            end;
            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
            begin
             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=4 ;
            end;

            MainForm.RegfournisseurTable.Post;
            MainForm.RegfournisseurTable.Refresh;

          end else
              begin
                    MainForm.RegfournisseurTable.DisableControls;
                    MainForm.RegfournisseurTable.Active:=false;
                    MainForm.RegfournisseurTable.SQL.Clear;
                    MainForm.RegfournisseurTable.SQL.Text:='SELECT * FROM regfournisseur WHERE code_bacom ='+IntToStr(DataModuleF.Bona_comTable.FieldValues['code_bacom']);
                    MainForm.RegfournisseurTable.Active:=True;

                 if NOT (MainForm.RegfournisseurTable.IsEmpty) then
                  begin
                  MainForm.RegfournisseurTable.Edit;
                  MainForm.RegfournisseurTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
                  MainForm.RegfournisseurTable.FieldValues['nom_rf']:= BonComAGestionF.NumBonComGEdt.Caption;
                  MainForm.RegfournisseurTable.FieldValues['code_f']:= MainForm.SQLQuery.FieldByName('code_f').AsInteger;
                  MainForm.RegfournisseurTable.FieldValues['date_rf']:= BonComAGestionF.DateBonComGD.DateTime;
                  MainForm.RegfournisseurTable.FieldValues['time_rf']:=TimeOf(Now);
                  MainForm.RegfournisseurTable.FieldValues['code_mdpai']:= MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
                  MainForm.RegfournisseurTable.FieldValues['code_cmpt']:= MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
                  MainForm.RegfournisseurTable.FieldValues['obser_rf']:= BonComAGestionF.ObserBonComGMem.Text;
                  MainForm.RegfournisseurTable.FieldValues['num_cheque_rf']:= BonComAGestionF.NChequeBonComGCbx.Text;
                  MainForm.RegfournisseurTable.FieldValues['bon_or_no_rf']:= 2;
                  MainForm.RegfournisseurTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);

                  MainForm.RegfournisseurTable.FieldByName('montver_rf').AsCurrency:=StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

                  if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='espece') then
                  begin
                   MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=1 ;
                  end;
                   if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='cheque') then
                  begin
                   MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=2 ;
                  end;
                  if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='a terme' )
                     OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) then
                  begin
                   MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=3 ;
                  end;
                  if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
                  begin
                   MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=4 ;
                  end;

                  MainForm.RegfournisseurTable.Post;
                  MainForm.RegfournisseurTable.Refresh;

                  end else
                      begin
                         MainForm.RegfournisseurTable.Active:=false;
                         MainForm.RegfournisseurTable.SQL.Clear;
                         MainForm.RegfournisseurTable.SQL.Text:='SELECT * FROM regfournisseur ';
                         MainForm.RegfournisseurTable.Active:=True;

                                if NOT (MainForm.RegfournisseurTable.IsEmpty) then
                            begin
                            MainForm.RegfournisseurTable.Last;
                            CodeRF:= MainForm.RegfournisseurTable.FieldValues['code_rf'] + 1;
                            end else
                                begin
                                 CodeRF:= 1;
                                end;

                            MainForm.RegfournisseurTable.Append;
                            MainForm.RegfournisseurTable.FieldValues['code_rf']:= CodeRF;
                            MainForm.RegfournisseurTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
                            MainForm.RegfournisseurTable.FieldValues['nom_rf']:= BonComAGestionF.NumBonComGEdt.Caption;
                            MainForm.RegfournisseurTable.FieldValues['code_f']:= MainForm.SQLQuery.FieldByName('code_f').AsInteger;
                            MainForm.RegfournisseurTable.FieldValues['date_rf']:= BonComAGestionF.DateBonComGD.DateTime;;
                            MainForm.RegfournisseurTable.FieldValues['time_rf']:=TimeOf(Now);
                            MainForm.RegfournisseurTable.FieldValues['code_mdpai']:= MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
                            MainForm.RegfournisseurTable.FieldValues['code_cmpt']:= MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
                            MainForm.RegfournisseurTable.FieldValues['obser_rf']:= BonComAGestionF.ObserBonComGMem.Text;
                            MainForm.RegfournisseurTable.FieldValues['num_cheque_rf']:= BonComAGestionF.NChequeBonComGCbx.Text;
                            MainForm.RegfournisseurTable.FieldValues['bon_or_no_rf']:= 2;
                            MainForm.RegfournisseurTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);

                            MainForm.RegfournisseurTable.FieldByName('montver_rf').AsCurrency:=StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

                            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='espece') then
                            begin
                             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=1 ;
                            end;
                             if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='cheque') then
                            begin
                             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=2 ;
                            end;
                            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='a terme' )
                               OR (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='� terme' ) then
                            begin
                             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=3 ;
                            end;
                            if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
                            begin
                             MainForm.RegfournisseurTable.FieldValues['code_mdpai']:=4 ;
                            end;

                            MainForm.RegfournisseurTable.Post;
                            MainForm.RegfournisseurTable.Refresh;
                      end;

                    MainForm.RegfournisseurTable.Active:=false;
                    MainForm.RegfournisseurTable.SQL.Clear;
                    MainForm.RegfournisseurTable.SQL.Text:='SELECT * FROM regfournisseur ';
                    MainForm.RegfournisseurTable.Active:=True;
                    MainForm.RegfournisseurTable.EnableControls;
              end;
    //-----------------------------------------------------------------------------------------------------------------------------------
          end;

          MainForm.SQLQuery.Edit;
          MainForm.SQLQuery.FieldByName('credit_f').AsCurrency:=
          ((StrToCurr(StringReplace(BonComAGestionF.BonComGFourNEWCredit.Caption, #32, '', [rfReplaceAll]))));
          MainForm.SQLQuery.Post;

          MainForm.SQLQuery.Active:=false;
          MainForm.SQLQuery.SQL.Clear;
//          MainForm.SQLQuery.SQL.Text:='Select * FROM fournisseur' ;
//          MainForm.SQLQuery.Active:=True;
//          MainForm.SQLQuery.EnableControls;

         //--- this is for adding the money to the caisse----
         begin
         if BonComAGestionF.Tag=0 then
           begin
            MainForm.Opt_cas_bnk_CaisseTable.DisableControls;
            MainForm.Opt_cas_bnk_CaisseTable.Filtered:=false;
            MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
            MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
            MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk' ;
            MainForm.Opt_cas_bnk_CaisseTable.Active:=True;

            if NOT (MainForm.Opt_cas_bnk_CaisseTable.IsEmpty) then
            begin
            MainForm.Opt_cas_bnk_CaisseTable.Last;
            CodeOCB:= MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ocb'] + 1;
            end else
                begin
                 CodeOCB:= 1;
                end;
              MainForm.Opt_cas_bnk_CaisseTable.Append;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ocb']:= CodeOCB;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['date_ocb']:= BonComAGestionF.DateBonComGD.DateTime;;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['time_ocb']:= TimeOf(Now);
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nom_ocb']:= 'Versement au Fournisseur pi�ce N� '+BonComAGestionF.NumBonComGEdt.Caption;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['third_ocb']:= BonComAGestionF.FournisseurBonComGCbx.Text;
      //        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['encaiss_ocb']:= StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));
             MainForm.Opt_cas_bnk_CaisseTable.FieldValues['decaiss_ocb']:= StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

               if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='espece') then
              begin
               MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=1 ;
              end;
               if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='cheque') then
              begin
               MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=2 ;
              end;
              if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='a terme' )
                 OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) then
              begin
               MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=3 ;
              end;
              if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
              begin
               MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=4 ;
              end;

              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_cmpt']:=MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nature_ocb']:= MainForm.CompteTable.FieldByName('nature_cmpt').AsBoolean;
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
              MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);
              MainForm.Opt_cas_bnk_CaisseTable.Post;
              MainForm.Opt_cas_bnk_CaisseTable.Refresh;
              MainForm.Opt_cas_bnk_BankTable.Refresh;

              MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
              MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
              MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk where nature_ocb = false' ;
              MainForm.Opt_cas_bnk_CaisseTable.Active:=True;
              MainForm.Opt_cas_bnk_CaisseTable.EnableControls;

          end else
              begin
                    MainForm.Opt_cas_bnk_CaisseTable.DisableControls;
                    MainForm.Opt_cas_bnk_CaisseTable.Filtered:=false;
                    MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
                    MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
                    MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk WHERE code_bacom ='+IntToStr(DataModuleF.Bona_comTable.FieldValues['code_bacom']); ;
                    MainForm.Opt_cas_bnk_CaisseTable.Active:=True;

                if NOT (MainForm.Opt_cas_bnk_CaisseTable.IsEmpty) Then
                begin
                     MainForm.Opt_cas_bnk_CaisseTable.Edit;
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['date_ocb']:= BonComAGestionF.DateBonComGD.DateTime;;
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['time_ocb']:= TimeOf(Now);
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nom_ocb']:= 'Versement au Fournisseur pi�ce N� '+BonComAGestionF.NumBonComGEdt.Caption;
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['third_ocb']:= BonComAGestionF.FournisseurBonComGCbx.Text;
                     MainForm.Opt_cas_bnk_CaisseTable.FieldValues['decaiss_ocb']:= StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

                       if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='espece') then
                      begin
                       MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=1 ;
                      end;
                       if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='cheque') then
                      begin
                       MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=2 ;
                      end;
                      if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='a terme' )
                         OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) then
                      begin
                       MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=3 ;
                      end;
                      if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
                      begin
                       MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=4 ;
                      end;
                      MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_cmpt']:=MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
                      MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nature_ocb']:= MainForm.CompteTable.FieldByName('nature_cmpt').AsBoolean;
                      MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
                      MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);
                      MainForm.Opt_cas_bnk_CaisseTable.Post;
                      MainForm.Opt_cas_bnk_CaisseTable.Refresh;
                      MainForm.Opt_cas_bnk_BankTable.Refresh;

                 end else
                   begin
                    MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
                    MainForm.Opt_cas_bnk_CaisseTable.Filtered:=false;
                    MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
                    MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk ' ;
                    MainForm.Opt_cas_bnk_CaisseTable.Active:=True;

                      if NOT (MainForm.Opt_cas_bnk_CaisseTable.IsEmpty) then
                      begin
                      MainForm.Opt_cas_bnk_CaisseTable.Last;
                      CodeOCB:= MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ocb'] + 1;
                      end else
                          begin
                           CodeOCB:= 1;
                          end;
                        MainForm.Opt_cas_bnk_CaisseTable.Append;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ocb']:= CodeOCB;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['date_ocb']:= BonComAGestionF.DateBonComGD.DateTime;;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['time_ocb']:= TimeOf(Now);
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=MainForm.Mode_paiementTable.FieldByName('code_mdpai').AsInteger;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nom_ocb']:= 'Versement au Fournisseur pi�ce N� '+BonComAGestionF.NumBonComGEdt.Caption;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['third_ocb']:= BonComAGestionF.FournisseurBonComGCbx.Text;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['decaiss_ocb']:= StrToCurr(StringReplace(VerVersementSEdt.Text, #32, '', [rfReplaceAll]));

                         if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='esp�ce') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='espece') then
                        begin
                         MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=1 ;
                        end;
                         if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='ch�que') OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='cheque') then
                        begin
                         MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=2 ;
                        end;
                        if (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='a terme' )
                           OR (LowerCase(BonComAGestionF.ModePaieBoncomGCbx.Text)='� terme' ) then
                        begin
                         MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=3 ;
                        end;
                        if (LowerCase(BonComAGestionF.ModePaieBonComGCbx.Text)='virement' ) then
                        begin
                         MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_mdpai']:=4 ;
                        end;

                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_cmpt']:=MainForm.CompteTable.FieldByName('code_cmpt').AsInteger;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['nature_ocb']:= MainForm.CompteTable.FieldByName('nature_cmpt').AsBoolean;
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_bacom']:= DataModuleF.Bona_comTable.FieldValues['code_bacom'];
                        MainForm.Opt_cas_bnk_CaisseTable.FieldValues['code_ur']:= StrToInt(MainForm.UserIDLbl.Caption);
                        MainForm.Opt_cas_bnk_CaisseTable.Post;
                        MainForm.Opt_cas_bnk_CaisseTable.Refresh;
                        MainForm.Opt_cas_bnk_BankTable.Refresh;

                        MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
                        MainForm.Opt_cas_bnk_CaisseTable.Filtered:=false;
                        MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
                        MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk where nature_ocb = false' ;
                        MainForm.Opt_cas_bnk_CaisseTable.Active:=True;
                   end;
                MainForm.Opt_cas_bnk_CaisseTable.Active:=false;
                MainForm.Opt_cas_bnk_CaisseTable.Filtered:=false;
                MainForm.Opt_cas_bnk_CaisseTable.SQL.Clear;
                MainForm.Opt_cas_bnk_CaisseTable.SQL.Text:='SELECT * FROM opt_cas_bnk where nature_ocb = false' ;
                MainForm.Opt_cas_bnk_CaisseTable.Active:=True;
                MainForm.Opt_cas_bnk_CaisseTable.EnableControls;
              end;
         end;

          MainForm.Mode_paiementTable.Active:=false;
          MainForm.Mode_paiementTable.SQL.Clear;
          MainForm.Mode_paiementTable.SQL.Text:='Select * FROM mode_paiement' ;
          MainForm.Mode_paiementTable.Active:=True;
          MainForm.Mode_paiementTable.EnableControls;

          MainForm.CompteTable.Active:=false;
          MainForm.CompteTable.SQL.Clear;
          MainForm.CompteTable.SQL.Text:='Select * FROM compte' ;
          MainForm.CompteTable.Active:=True;
          MainForm.CompteTable.EnableControls;
       end;

   end else
      begin
      try
        VerVersementSEdt.BorderStyle := bsNone;
        VerVersementSEdt.StyleElements := [];
        RequiredVerVersementSlbl.Visible := true;
        VerVersementSErrorP.Visible := true;
        sndPlaySound('C:\Windows\Media\Windows Hardware Fail.wav',
          SND_NODEFAULT Or SND_ASYNC Or SND_RING);
        OKVersementSBtn.Enabled := false;
        OKVersementSBtn.ImageIndex := 18;
      finally
        VerVersementSEdt.SetFocus;
      end;
     end;

   end;