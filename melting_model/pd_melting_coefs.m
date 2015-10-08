function n=pd_melting_coefs(X,P)    

n=zeros(1,7);
%k=1  2    3   4   5  6   7
%  ol opx cpx plag sp gt melt

for k=1:7

        % Melting reaction coefficients
        %..which minerals are present in the residue?
        if X(6)>0 && X(3)>0 && X(2)>0
            n_gt1=[-0.071.*P+0.105,0.193.*P-0.123,-0.050.*P-0.923,0,0,-0.0072.*P-0.059,1];
        else if X(6)>0 && X(3)>0
                n_gt1=[-0.059*P+0.025,0,0.034*P-0.6295,0,0,0.024*P-0.3915,1];
            else if X(6)>0 && X(2)>0
                    n_gt1=[-0.13,-0.62,0,0,0,-0.25,1];
                else if X(6)>0
                        n_gt1=[-0.68,0,0,0,0-0.32,1];
                    else if X(2)>0 && X(3)>0
                            n_gt1=[-0.09,0.56,-1.47,0,0,0,1];
                        else if X(2)>0
                                n_gt1=[-0.03,-0.97,0,0,0,0,1];
                            else n_gt1=[-1,0,0,0,0,0,1];
                                
                            end
                        end
                    end
                end
            end
        end
        
        if X(6)>0 && X(3)>0 && X(2)>0
            n_gt2=[-0.069*P+0.0624,-0.274*P+1.7065,0.216*P-1.8737,0,0,0.127*P-0.8952,1];
        else if X(6)>0 && X(2)>0
                n_gt2=[-0.13,-0.62,0,0,0,-0.25,1];
            else if X(6)>0
                    n_gt2=[-0.68,0,0,0,0,-0.32,1];
                else if X(2)>0 && X(3)>0
                        n_gt2=[-0.09,0.56,-1.47,0,0,0,1];
                    else if X(2)>0
                            n_gt2=[-0.03,-0.97,0,0,0,0,1];
                        else n_gt2=[-1,0,0,0,0,0,1];
                            
                        end
                    end
                end
            end
        end
        
        if X(6)>0 && X(3)>0 && X(2)>0
            n_gt3=[-0.076*P+0.0835,0.045*P+0.7887,-0.134*P-0.8653,0,0,+0.165*P-1.0069,1];
        else if X(6)>0 && X(2)>0
                n_gt3=[-0.13,-0.62,0,0,0,-0.25,1];
            else if X(6)>0
                    n_gt3=[-0.68,0,0,0,0-0.32,1];
                else if X(2)>0 && X(3)>0
                        n_gt3=[-0.09,0.56,-1.47,0,0,0,1];
                    else if X(2)>0
                            n_gt3=[-0.03,-0.97,0,0,0,0,1];
                        else n_gt3=[-1,0,0,0,0,0,1];
                            
                        end
                    end
                end
            end
        end
        
        if X(3)>0 && X(5)>0
            n_sp=[-0.161*P+0.4101,+0.327*P-0.3324,-0.214*P-0.8262,0,0.048*P-0.2515,0,1];
        else if X(5)>0
                n_sp=[0.10,-1.06,0,0,-0.04,0,1];
            else if X(3)>0
                    n_sp=[-0.09,0.56,-1.47,0,0,0,1];
                else if X(2)>0
                        n_sp=[0.24,-1.24,0,0,0,0,1];
                    else n_sp=[-1,0,0,0,0,0,1];
                    end
                end
            end
        end
        
        if X(3)>0 && X(4)>0
            n_plag=[-0.543*P+0.1252,0.969*P-0.5215,0.018*P-0.2668,-0.444*P-0.3369,0,0,1];
        else if X(4)>0
                n_plag=[-0.059,-0.376,0,-0.565,0,0,1];
            else if X(3)>0
                    n_plag=[-0.09,0.56,-1.47,0,0,0,1];
                else if X(2)>0
                        n_plag=[0.21,-1.21,0,0,0,0,1];
                    else n_plag=[-1,0,0,0,0,0,1];
                    end
                end
            end
        end
        
        %..Which stability field is it in?
        %Transition pressures:
        Psp_in=pd_Psp_in();
        Pgt_out=pd_Pgt_out();
        Pplag_in=pd_Pplag_in();
        Psp_out=pd_Psp_out();
        
        if P>4.1
            n(k)=n_gt1(k);
        else if P>2.8
                n(k)=n_gt2(k);
            else if P>Psp_in
                    n(k)=n_gt3(k);
                else if P>Pgt_out && X(5)+X(6)>0
                        n(k)=(X(5)./(X(5)+X(6))).*n_sp(k)+(X(6)./(X(5)+X(6))).*n_gt3(k);
                    else if P>Pgt_out
                            n(k)=0.5*n_sp(k)+0.5*n_gt3(k);
                        else if P>Pplag_in
                                n(k)=n_sp(k);
                            else if P>Psp_out && X(4)+X(5)>0
                                    n(k)=(X(4)./(X(4)+X(5))).*n_plag(k)+(X(5)./(X(4)+X(5)))*n_sp(k);
                                else if P>Psp_out
                                        n(k)=0.5*n_plag(k)+0.5*n_sp(k);
                                    else n(k)=n_plag(k);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
end